//
//  AuthenticationStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/21.
//

import AuthenticationServices
import Combine
import SwiftUI

class AuthenticationStore: NSObject, ObservableObject {
    enum AuthenticationError: Error {
        case unexpectedError
        case unexpectedlyCancelled
        case internalInconsistency
        case couldNotFetchTemporaryCode
        case couldNotEncodeCredentials
        case invalidURL
    }
    
    enum State {
        case initial
        case inProgress
        case authenticated(userType: UserType)
        case needsRegistration(googleCredentials: GoogleCredentials, googleProfileInfo: GoogleProfileInfo)
        case failed(error: Error)
    }
    
    private static let clientID = "803393338232-c543gp0m57ha3tnoc063agp45ntt40ig.apps.googleusercontent.com"
    private static let redirectURI = "com.googleusercontent.apps.803393338232-c543gp0m57ha3tnoc063agp45ntt40ig://"
    
    private static let oauthURL: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.google.com"
        components.path = "/o/oauth2/v2/auth"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: AuthenticationStore.clientID),
            URLQueryItem(name: "include_granted_scopes", value: "true"),
            URLQueryItem(name: "response_type", value: "code"),
            //URLQueryItem(name: "scope", value: "https://www.googleapis.com/auth/userinfo.profile"),
            URLQueryItem(name: "scope", value: "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email"),
            URLQueryItem(name: "redirect_uri", value: AuthenticationStore.redirectURI)
        ]
        return components.url
    }()
    
    @Published var state: State = .initial
    
    var finishAuthenticationCancellable: AnyCancellable?
    var webAuthSession: ASWebAuthenticationSession?
    
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        if
            KeychainService.shared.has(key: .accessToken),
            let rawUserType = KeychainService.shared.get(key: .userType),
            let userType = UserType(rawValue: rawUserType)
        {
            state = .authenticated(userType: userType)
        }
    }
}

// MARK: - Authenticate
extension AuthenticationStore {
    func authenticate(with token: String, userType: UserType) {
        KeychainService.shared.set(key: .accessToken, value: token)
        KeychainService.shared.set(key: .userType, value: userType.rawValue)
        
        state = .authenticated(userType: userType)
    }
    
    func authenticate() {
        guard let oauthURL = Self.oauthURL else {
            // AuthenticationError.urlNotFound
            return
        }
        
        let callbackURLScheme = Self.redirectURI
        
        state = .inProgress
        
        webAuthSession = ASWebAuthenticationSession(
            url: oauthURL,
            callbackURLScheme: callbackURLScheme,
            completionHandler: { [weak self] url, error in
                guard let strongSelf = self else {
                    self?.state = .failed(error: AuthenticationError.unexpectedlyCancelled)
                    
                    return
                }
                
                if error != nil {
                    self?.state = .failed(error: AuthenticationError.unexpectedError)
                    
                    return
                }
                
                guard
                    let url = url,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    let codeQueryItem = components.queryItems?.first(where: { $0.name == "code" }),
                    let temporaryCode = codeQueryItem.value
                else {
                    self?.state = .failed(error: AuthenticationError.couldNotFetchTemporaryCode)
                    
                    return
                }
                
                var googleCredentials: GoogleCredentials?
                var googleProfileInfo: GoogleProfileInfo?
                
                strongSelf.exchangeCodeForAccessToken(code: temporaryCode)
                    .handleEvents(receiveOutput: {
                        googleCredentials = $0
                    })
                    .flatMap { googleCredentials in
                        strongSelf.getProfileInfo(googleCredentials: googleCredentials)
                    }
                    .handleEvents(receiveOutput: {
                        googleProfileInfo = $0
                    })
                    .flatMap { profileInfo -> AnyPublisher<APICredentials, Error> in
                        guard let googleCredentials = googleCredentials else {
                            return Fail(error: AuthenticationError.internalInconsistency)
                                .eraseToAnyPublisher()
                        }
                        
                        return strongSelf.authenticate(
                            googleProfileInfo: profileInfo,
                            googleCredentials: googleCredentials
                        )
                    }
                    .receive(on: DispatchQueue.main)
                    .sink(
                        receiveCompletion: { result in
                            switch result {
                            case .finished:
                                break
                            case let .failure(error):
                                strongSelf.state = .failed(error: error)
                            }
                        },
                        receiveValue: { credentials in
                            if let token = credentials.token, let userType = credentials.userType {
                                strongSelf.authenticate(with: token, userType: userType)
                                
                                return
                            }
                            
                            guard
                                let googleCredentials = googleCredentials,
                                let googleProfileInfo = googleProfileInfo
                            else {
                                strongSelf.state = .failed(error: AuthenticationError.internalInconsistency)
                                
                                return
                            }
                            
                            strongSelf.state = .needsRegistration(
                                googleCredentials: googleCredentials,
                                googleProfileInfo: googleProfileInfo
                            )
                        }
                    )
                    .store(in: &strongSelf.cancellables)
            }
        )
        
        webAuthSession?.presentationContextProvider = self
        webAuthSession?.start()
    }
    
    func exchangeCodeForAccessToken(code: String) -> AnyPublisher<GoogleCredentials, Error> {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Self.clientID),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: Self.redirectURI),
            URLQueryItem(name: "code", value: code)
        ]

        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]

        guard let requestURL = URL(string: "https://oauth2.googleapis.com/token") else {
            return Fail(error: AuthenticationError.invalidURL)
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = components.query?.data(using: .utf8)

        return APIService.shared.request(request, authenticated: false)
            .eraseToAnyPublisher()
    }
    
    func getProfileInfo(googleCredentials: GoogleCredentials) -> AnyPublisher<GoogleProfileInfo, Error> {
        guard let requestURL = URL(string: "https://www.googleapis.com/oauth2/v3/userinfo") else {
            return Fail(error: AuthenticationError.invalidURL)
                .eraseToAnyPublisher()
        }

        let headers: [String: String] = ["Authorization": "Bearer \(googleCredentials.accessToken)"]

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        return APIService.shared.request(request, authenticated: false)
            .eraseToAnyPublisher()
    }
    
    func authenticate(googleProfileInfo: GoogleProfileInfo, googleCredentials: GoogleCredentials) -> AnyPublisher<APICredentials, Error> {
        guard let requestURL = URL(string: "\(APIService.baseURLString)/auth/v1/authenticate.php") else {
            return Fail(error: AuthenticationError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let payload = AuthenticationRequestPayload(email: googleProfileInfo.email, googleCredentials: googleCredentials)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        guard let data = try? APIService.shared.jsonEncoder.encode(payload) else {
            return Fail(error: AuthenticationError.couldNotEncodeCredentials)
                .eraseToAnyPublisher()
        }
        
        request.httpBody = data
        
        return APIService.shared.request(request, authenticated: false)
            .eraseToAnyPublisher()
    }
}

// MARK: - Sign out
extension AuthenticationStore {
    func signOut() {
        KeychainService.shared.remove(key: .accessToken)
        KeychainService.shared.remove(key: .userType)
        
        state = .initial
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension AuthenticationStore: ASWebAuthenticationPresentationContextProviding {
    // Not great, not terrible - there is no way to get the ASPresentationAnchor in SwiftUI without UIKit
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        for scene in UIApplication.shared.connectedScenes where scene.activationState == .foregroundActive {
            return ((scene as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window!!
        }

        fatalError("No window?!")
    }
}

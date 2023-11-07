//
//  MyPostsStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/8/2021.
//

import Combine
import Foundation

class MyPostsStore: ObservableObject {
    enum State {
        case ready
        case loading
        case success(posts: [Post])
        case failed(error: Error)
    }
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchPosts() {
        state = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/post/v1/my-posts.php")!
        
        let request = URLRequest(url: url)
        
        APIService.shared.request(request)
            .receive(on: DispatchQueue.main)
            .map { (posts: [Post]) in
                .success(posts: posts)
            }
            .catch { error in
                Just(.failed(error: error))
                    .eraseToAnyPublisher()
            }
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

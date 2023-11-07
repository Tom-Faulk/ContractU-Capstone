//
//  AuthenticationView.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/21.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    @State var showRegistrationAlert = false
    @State var openUserTypeChoice = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            NavigationLink(
                destination: RegistrationView(),
                isActive: $openUserTypeChoice
            ) {
                EmptyView()
            }
            
            Spacer()
            
            Text("Please sign in or register")
            
            Spacer()
            
            Button(action: authenticate) {
                Text("Continue with Google")
            }
            .buttonStyle(AppBigButtonStyle())
            .alert(isPresented: $showRegistrationAlert) {
                Alert(
                    title: Text("We don't know you yet"),
                    message: Text("Please register..."),
                    primaryButton: .default(Text("OK!")) {
                        openUserTypeChoice = true
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .navigationTitle("Authentication")
        .onReceive(authenticationStore.$state) { state in
            switch state {
            case .needsRegistration:
                showRegistrationAlert = true
            default:
                return
            }
        }
    }
}

extension AuthenticationView {
    func authenticate() {
        authenticationStore.authenticate()
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}

//
//  LoginView.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 16) {
            NavigationLink(
                destination: LoginWithEmailView()
            ) {
                Text("Sign in using e-mail (business/personal)")
            }
            
            Button(action: loginWithGoogle) {
                Text("Sign in with Google (personal)")
            }
        }
        .navigationTitle(Text("Sign in method"))
    }
}

extension LoginView {
    func loginWithGoogle() {
        print("Sign in with Google")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

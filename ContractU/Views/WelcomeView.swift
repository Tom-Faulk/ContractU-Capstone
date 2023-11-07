//
//  WelcomeView.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                
                Text("Contract-U")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.blue)
                
                Spacer()
                
                NavigationLink(destination: AuthenticationView()) {
                    Text("Get Started!")
                }
                .buttonStyle(AppBigButtonStyle())
                
//                HStack {
//                    Text("Already a member?")
//
//                    NavigationLink(destination: LoginView()) {
//                        Text("Sign in")
//                    }
//                }
                
                Spacer()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

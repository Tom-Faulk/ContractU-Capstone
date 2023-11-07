//
//  ContentView.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authenticationStore = AuthenticationStore()
    
    var body: some View {
        Group {
            switch authenticationStore.state {
            case .authenticated:
                MainView()
            default:
                WelcomeView()
            }
        }
        .environmentObject(authenticationStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

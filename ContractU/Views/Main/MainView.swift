//
//  MainView.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/12/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    var body: some View {
        switch authenticationStore.state {
        case let .authenticated(userType):
            TabView {
                if case .person = userType {
                    NavigationView {
                        BusinessListView()
                    }
                    .tabItem {
                        Label("Businesses", systemImage: "building.2")
                    }
                }
                
                switch userType {
                case .person:
                    NavigationView {
                        PostFeedView()
                    }
                    .tabItem {
                        Label("Posts", systemImage: "list.bullet.rectangle")
                    }
                    
                    NavigationView {
                        MyRequestsView()
                    }
                    .tabItem {
                        Label("My Requests", systemImage: "plus.rectangle.on.rectangle")
                    }
                case .business:
                    NavigationView {
                        RequestFeedView()
                    }
                    .tabItem {
                        Label("Requests", systemImage: "list.bullet.rectangle")
                    }
                    
                    NavigationView {
                        MyPostsView()
                    }
                    .tabItem {
                        Label("My Posts", systemImage: "plus.rectangle.on.rectangle")
                    }
                }
                
                NavigationView {
                    switch userType {
                    case .person:
                        PersonalProfileView()
                    case .business:
                        BusinessProfileView()
                    }
                }
                .tabItem {
                    Label(
                        "Profile",
                        systemImage: userType == .person ? "person" : "building.2.crop.circle"
                    )
                }
            }
        default:
            Text("Loading...")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

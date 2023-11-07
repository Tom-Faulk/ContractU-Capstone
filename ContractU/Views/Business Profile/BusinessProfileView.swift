//
//  BusinessProfileView.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/31/21.
//

import SwiftUI

struct BusinessProfileView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var store = BusinessProfileStore()
    
    var body: some View {
        ScrollView {
            VStack {
                switch store.state {
                case let .success(business):
                    VStack {
                        Group {
                            if let photoUrl = business.photoUrl {
                                AsyncImage(url: photoUrl) {
                                    photoPlaceholder
                                }
                            } else {
                                photoPlaceholder
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 75)
                        .padding(.bottom, 16)
                        
                        HStack {
                            Text("Name")
                            
                            Spacer()
                            
                            Text(business.companyName)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Website")
                            
                            Spacer()
                            
                            Button(action: { openURL(business: business) }) {
                                Text(business.companyUrl)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        HStack {
                            Text("Phone number")
                            
                            Spacer()
                            
                            Text(business.phoneNumber)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Address")
                            
                            Spacer()
                            
                            Text(business.address)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("ZIP code")
                            
                            Spacer()
                            
                            Text(business.zipCode)
                                .fontWeight(.bold)
                        }
                        
                        Text(business.companyDescription)
                    }
                    .padding()
                    
                    NavigationLink(destination: EditBusinessProfileView(business: business)) {
                        Text("Edit profile")
                    }
                default:
                    EmptyView()
                }
                
                Button(action: signOut) {
                    Text("Sign out")
                }
            }
        }
        .navigationTitle(Text("Profile"))
        .onAppear {
            store.fetch()
        }
    }
    
    var photoPlaceholder: some View {
        Image(systemName: "building.2")
            .resizable()
            .padding(16)
    }
}

extension BusinessProfileView {
    func openURL(business: Business) {
        guard
            let url = URL(string: business.companyUrl),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func signOut() {
        authenticationStore.signOut()
    }
}

struct BusinessProfileView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessProfileView()
    }
}

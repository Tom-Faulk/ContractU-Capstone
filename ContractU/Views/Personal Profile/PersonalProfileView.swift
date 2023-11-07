//
//  PersonalProfileView.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/12/21.
//

import SwiftUI

struct PersonalProfileView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var store = PersonalProfileStore()
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: signOut) {
                    Text("Sign out")
                }
                
                switch store.profileState {
                case let .success(person):
                    VStack {
                        Group {
                            if let photoUrl = person.photoUrl {
                                AsyncImage(url: photoUrl) {
                                    photoPlaceholder
                                }
                            } else {
                                photoPlaceholder
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 75)
                        
                        VStack(spacing: 4) {
                            NavigationLink(destination: EditPersonalProfileView(person: person)) {
                                Text("Edit profile")
                            }
                        }
                        .padding()
                        
                        HStack {
                            Text("First name")
                            
                            Spacer()
                            
                            Text(person.firstName)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Last name")
                            
                            Spacer()
                            
                            Text(person.lastName)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Phone number")
                            
                            Spacer()
                            
                            Text(person.phoneNumber)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("ZIP code")
                            
                            Spacer()
                            
                            Text(person.zipCode)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                default:
                    EmptyView()
                }
                
                VStack(alignment: .leading) {
                    Text("My appointments")
                        .font(.title)
                    
                    switch store.appointmentsState {
                    case let .success(appointments):
                        LazyVStack(alignment: .leading) {
                            ForEach(appointments) { appointment in
                                PersonalProfileAppointmentView(appointment: appointment)
                            }
                        }
                    default:
                        EmptyView()
                    }
                }
                .padding()
            }
        }
        .navigationTitle(Text("Profile"))
        .onAppear {
            store.fetch()
        }
    }
    
    var photoPlaceholder: some View {
        Image(systemName: "person")
            .resizable()
            .padding(16)
    }
}

extension PersonalProfileView {
    func signOut() {
        authenticationStore.signOut()
    }
}

struct PersonalProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileView()
    }
}

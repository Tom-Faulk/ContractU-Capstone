//
//  MyRequestsView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/8/2021.
//

import SwiftUI

struct MyRequestsView: View {
    @StateObject var store = MyRequestsStore()
    
    @State var isCreateRequestPresented = false
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    switch store.state {
                    case .ready, .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Could not fetch requests")
                    case let .success(requests):
                        ForEach(requests) { request in
                            RequestFeedItemView(request: request)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("My requests"))
        .navigationBarItems(trailing: Button(action: createRequest) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isCreateRequestPresented) {
            NavigationView {
                CreateRequestView()
            }
        }
        .onAppear {
            store.fetchRequests()
        }
        .onChange(of: isCreateRequestPresented) { isPresented in
            guard !isPresented else {
                return
            }
            
            store.fetchRequests()
        }
    }
    
    func createRequest() {
        isCreateRequestPresented = true
    }
}

struct MyRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRequestsView()
    }
}

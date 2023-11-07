//
//  RequestFeedView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/2/2021.
//

import SwiftUI

struct RequestFeedView: View {
    @StateObject var store = RequestFeedStore()
    
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
        .navigationTitle(Text("Requests"))
        .onAppear {
            store.fetchRequests()
        }
    }
}

struct RequestFeedView_Previews: PreviewProvider {
    static var previews: some View {
        RequestFeedView()
    }
}

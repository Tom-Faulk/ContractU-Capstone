//
//  PostFeedView.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/13/2021.
//

import SwiftUI

struct PostFeedView: View {
    @StateObject var store = PostFeedStore()
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    switch store.state {
                    case .ready, .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Could not fetch posts")
                    case let .success(posts):
                        ForEach(posts) { post in
                            PostFeedItemView(post: post)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Posts"))
        .onAppear {
            store.fetchPosts()
        }
    }
}

struct PostFeedView_Previews: PreviewProvider {
    static var previews: some View {
        PostFeedView()
    }
}

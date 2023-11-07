//
//  MyPostsView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/8/2021.
//

import SwiftUI

struct MyPostsView: View {
    @StateObject var store = MyPostsStore()
    
    @State var isCreatePostPresented = false
    
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
        .navigationTitle(Text("My posts"))
        .navigationBarItems(trailing: Button(action: createPost) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isCreatePostPresented) {
            NavigationView {
                CreatePostView()
            }
        }
        .onAppear {
            store.fetchPosts()
        }
        .onChange(of: isCreatePostPresented) { isPresented in
            guard !isPresented else {
                return
            }
            
            store.fetchPosts()
        }
    }
    
    func createPost() {
        isCreatePostPresented = true
    }
}

struct MyPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPostsView()
    }
}


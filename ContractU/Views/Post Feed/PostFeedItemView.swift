//
//  PostView.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/13/2021.
//

import SwiftUI

struct PostFeedItemView: View {
    static let images: [Image] = [
        Image(systemName: "person"),
        Image(systemName: "trash"),
        Image(systemName: "house"),
        Image(systemName: "tray"),
        Image(systemName: "paperplane")
    ]
    
    let post: Post
    
    var body: some View {
        HStack(spacing: 24) {
            Self.images.randomElement()!
                .resizable()
                .frame(width: 32, height: 32)
            
            VStack(spacing: 8) {
                Text(post.title)
                    .font(.headline)
                Text(post.description)
            }
        }
        .padding()
    }
}

struct PostFeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        PostFeedItemView(
            post: Post(
                id: 1,
                title: "Post",
                description: "A nice post",
                business: Business(
                    id: 1,
                    companyName: "ACME",
                    companyUrl: "www.acme.com",
                    companyDescription: "Some description",
                    phoneNumber: "123",
                    address: "Some address",
                    zipCode: "456",
                    photoPath: nil
                )
            )
        )
    }
}

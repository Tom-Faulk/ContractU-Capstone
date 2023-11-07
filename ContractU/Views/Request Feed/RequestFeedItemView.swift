//
//  RequestFeedItemView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/2/2021.
//

import SwiftUI

struct RequestFeedItemView: View {
    static let images: [Image] = [
        Image(systemName: "person"),
        Image(systemName: "trash"),
        Image(systemName: "house"),
        Image(systemName: "tray"),
        Image(systemName: "paperplane")
    ]
    
    let request: Request
    
    var body: some View {
        HStack(spacing: 24) {
            Self.images.randomElement()!
                .resizable()
                .frame(width: 32, height: 32)
            
            VStack(spacing: 8) {
                Text(request.title)
                    .font(.headline)
                Text(request.description)
            }
        }
        .padding()
    }
}

struct RequestFeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        RequestFeedItemView(
            request: Request(
                id: 1,
                title: "Request",
                description: "A nice request",
                person: Person(
                    id: 1,
                    firstName: "John",
                    lastName: "Doe",
                    phoneNumber: "123",
                    zipCode: "456",
                    photoPath: nil
                )
            )
        )
    }
}

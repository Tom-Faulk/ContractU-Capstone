//
//  BusinessListView.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/12/21.
//

import SwiftUI

struct BusinessListView: View {
    @StateObject var store = BusinessListStore()
    
    var body: some View {
        VStack {
            TextField("Search", text: $store.query)
                .padding(16)
            
            ScrollView {
                switch store.state {
                case let .success(businesses):
                    VStack {
                        ForEach(businesses) { business in
                            NavigationLink(
                                destination: BusinessDetailView(business: business)
                            ) {
                                HStack {
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
                                    .frame(width: 30)
                                    .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(business.companyName)
                                            .fontWeight(.bold)
                                        Text(business.companyDescription)
                                    }
                                    .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.compact.right")
                                }
                                .padding()
                            }
                            //.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                case .loading:
                    Text("Loading...")
                default:
                    EmptyView()
                }
            }
        }
        .navigationTitle(Text("Businesses"))
    }
    
    var photoPlaceholder: some View {
        Image(systemName: "building.2")
            .resizable()
    }
}

struct BusinessListView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListView()
    }
}

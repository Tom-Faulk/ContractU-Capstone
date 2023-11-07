//
//  CreatePostView.swift
//  ContractU
//
//  Created by Arthur Babcock on 3/13/21.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var store = CreatePostStore()
    
    @State var title = ""
    @State var description = ""
    
    var body: some View {
        ScrollView {
            VStack {
                FormElement(title: "Title") {
                    TextField("", text: $title)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Description") {
                    TextField("", text: $description)
                        .textFieldStyle(AppTextFieldStyle())
                }
            }
        }
        .padding(16)
        .navigationTitle("Create post")
        .navigationBarItems(
            trailing: Button(action: save) {
                Text("Save")
            }
        )
        .onReceive(store.$state) { state in
            guard case .success = state else {
                return
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func save() {
        store.save(title: title, description: description)
    }
}

struct CreatePost_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}

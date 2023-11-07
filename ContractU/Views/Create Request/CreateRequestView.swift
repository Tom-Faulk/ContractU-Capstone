//
//  CreateRequestView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/2/2021.
//

import SwiftUI

struct CreateRequestView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var store = CreateRequestStore()
    
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
        .navigationTitle("Create request")
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

struct CreateRequest_Previews: PreviewProvider {
    static var previews: some View {
        CreateRequestView()
    }
}

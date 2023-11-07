//
//  BookAppointmentView.swift
//  ContractU
//
//  Created by Eli Daitch on 4/17/2021.
//

import SwiftUI

struct BookAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var store: BookAppointmentStore
    
    @State var title = ""
    @State var description = ""
    @State var date = Date()
    
    init(business: Business) {
        _store = .init(
            wrappedValue: BookAppointmentStore(business: business)
        )
    }
    
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
                
                FormElement(title: "Date & time") {
                    HStack {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .fixedSize()
                        
                        DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .navigationTitle("Book an appointment")
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
}

extension BookAppointmentView {
    func save() {
        store.save(title: title, description: description, date: date)
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView(
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
    }
}

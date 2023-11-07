//
//  EditPersonalProfileView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import SwiftUI

struct EditPersonalProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var store: EditPersonalProfileStore
    
    @State var firstName = ""
    @State var lastName = ""
    @State var phoneNumber = ""
    @State var zipCode = ""
    @State var newPhoto: UIImage?
    
    @State var isShowingImagePicker = false
    
    init(person: Person) {
        _store = .init(
            wrappedValue: EditPersonalProfileStore(person: person)
        )
        
        _firstName = .init(initialValue: person.firstName)
        _lastName = .init(initialValue: person.lastName)
        _phoneNumber = .init(initialValue: person.phoneNumber)
        _zipCode = .init(initialValue: person.zipCode)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    if let newPhoto = newPhoto {
                        Image(uiImage: newPhoto)
                            .resizable()
                    } else if let photoUrl = store.person.photoUrl {
                        AsyncImage(url: photoUrl) {
                            photoPlaceholder
                        }
                    } else {
                        photoPlaceholder
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 75)
                .onTapGesture(perform: pickImage)
                .padding(.bottom, 16)
                
                FormElement(title: "First name") {
                    TextField("", text: $firstName)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Last name") {
                    TextField("", text: $lastName)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Phone #") {
                    TextField("", text: $phoneNumber)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Zipcode") {
                    TextField("", text: $zipCode)
                        .textFieldStyle(AppTextFieldStyle())
                }
            }
        }
        .padding(16)
        .navigationTitle("Update profile")
        .navigationBarItems(
            trailing: Button(action: submit) {
                Text("Submit")
            }
        )
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $newPhoto)
        }
        .onReceive(store.$state) { state in
            guard case .success = state else {
                return
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var photoPlaceholder: some View {
        Image(systemName: "person")
            .resizable()
            .padding(16)
    }
}

extension EditPersonalProfileView {
    func pickImage() {
        isShowingImagePicker = true
    }
    
    func submit() {
        store.save(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            zipCode: zipCode,
            newPhoto: newPhoto
        )
    }
}

struct EditPersonalProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditPersonalProfileView(
            person: Person(
                id: 1,
                firstName: "John",
                lastName: "Doe",
                phoneNumber: "123",
                zipCode: "456",
                photoPath: nil
            )
        )
    }
}

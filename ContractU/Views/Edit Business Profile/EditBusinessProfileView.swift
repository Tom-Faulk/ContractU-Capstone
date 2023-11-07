//
//  EditBusinessProfileView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import SwiftUI

struct EditBusinessProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var store: EditBusinessProfileStore
    
    @State var companyName = ""
    @State var companyURL = ""
    @State var phoneNumber = ""
    @State var address = ""
    @State var zipCode = ""
    //@State var emergencyServiceCallRadius: Double = 50
    @State var companyDescription = ""
    @State var newPhoto: UIImage?
    
    @State var isShowingImagePicker = false
    
    init(business: Business) {
        _store = .init(
            wrappedValue: EditBusinessProfileStore(business: business)
        )
        
        _companyName = .init(initialValue: business.companyName)
        _companyURL = .init(initialValue: business.companyUrl)
        _phoneNumber = .init(initialValue: business.phoneNumber)
        _address = .init(initialValue: business.address)
        _zipCode = .init(initialValue: business.zipCode)
        //_emergencyServiceCallRadius = .init(initialValue: business.emergencyServiceCallRadius)
        _companyDescription = .init(initialValue: business.companyDescription)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    if let newPhoto = newPhoto {
                        Image(uiImage: newPhoto)
                            .resizable()
                    } else if let photoUrl = store.business.photoUrl {
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
                
                FormElement(title: "Company name") {
                    TextField("", text: $companyName)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Company URL") {
                    TextField("", text: $companyURL)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Phone #") {
                    TextField("", text: $phoneNumber)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Address") {
                    TextField("", text: $address)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(title: "Zipcode") {
                    TextField("", text: $zipCode)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                /*FormElement(title: "Emergency Service Call Radius (\(Int(emergencyServiceCallRadius))mi)") {
                    Slider(value: $emergencyServiceCallRadius, in: 1...100, step: 1, minimumValueLabel: Text("1mi"), maximumValueLabel: Text("100mi")) {
                        Text("")
                    }
                }*/
                
                FormElement(title: "Company description") {
                    TextField("", text: $companyDescription)
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
        Image(systemName: "building.2")
            .resizable()
            .padding(16)
    }
}

extension EditBusinessProfileView {
    func pickImage() {
        isShowingImagePicker = true
    }

    func submit() {
        store.save(
            companyName: companyName,
            companyURL: companyURL,
            phoneNumber: phoneNumber,
            address: address,
            zipCode: zipCode,
            //emergencyServiceCallRadius: emergencyServiceCallRadius,
            companyDescription: companyDescription,
            newPhoto: newPhoto
        )
    }
}

struct EditBusinessProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditBusinessProfileView(
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

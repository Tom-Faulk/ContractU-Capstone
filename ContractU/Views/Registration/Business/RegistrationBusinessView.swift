//
//  RegistrationBusinessView.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct RegistrationBusinessView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var store = RegistrationBusinessStore()
    
    @State var hasSubmittedFormAtLeastOnce = false
    
    @State var companyName = ""
    @State var companyURL = ""
    @State var phoneNumber = ""
    @State var address = ""
    @State var zipCode = ""
    //@State var emergencyServiceCallRadius: Double = 50
    @State var companyDescription = ""
    @State var documentUrl: URL?
    
    var companyNameError: String? {
        if companyName.isEmpty {
            return "Company name must not be empty"
        }
        
        return nil
    }
    
    var companyURLError: String? {
        if companyURL.isEmpty {
            return "Company URL must not be empty"
        }
        
        if !companyURL.isValidURL {
            return "Company URL must be a valid URL"
        }
        
        return nil
    }
    
    var phoneNumberError: String? {
        if phoneNumber.isEmpty {
            return "Phone number must not be empty"
        }
        
        if !phoneNumber.isValidPhoneNumber {
            return "Phone number must in format: 000-000-0000"
        }
        
        return nil
    }
    
    var addressError: String? {
        if address.isEmpty {
            return "Address must not be empty"
        }
        
        return nil
    }
    
    var zipCodeError: String? {
        if zipCode.isEmpty {
            return "Zip code must not be empty"
        }
        
        if !zipCode.isValidZipCode {
            return "Zip code must in format: 00000 or 00000-0000"
        }
        
        return nil
    }
    
    var companyDescriptionError: String? {
        if companyDescription.isEmpty {
            return "Company description must not be empty"
        }
        
        return nil
    }
    
    var documentURLError: String? {
        if documentUrl == nil {
            return "License file must be selected"
        }
        
        return nil
    }
    
    var formHasErrors: Bool {
        return
            companyNameError != nil ||
            companyURLError != nil ||
            phoneNumberError != nil ||
            addressError != nil ||
            zipCodeError != nil ||
            companyDescriptionError != nil ||
            documentURLError != nil
    }
    
    @State var isShowingDocumentPicker = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if hasSubmittedFormAtLeastOnce && formHasErrors {
                    Text("Please correct the errors below")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.bottom, 8)
                }
                
                FormElement(
                    title: "Company name",
                    error: hasSubmittedFormAtLeastOnce ? companyNameError : nil
                ) {
                    TextField("", text: $companyName)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(
                    title: "Company URL",
                    error: hasSubmittedFormAtLeastOnce ? companyURLError : nil
                ) {
                    TextField("", text: $companyURL)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(
                    title: "Phone #",
                    error: hasSubmittedFormAtLeastOnce ? phoneNumberError : nil
                ) {
                    TextField("", text: $phoneNumber)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(
                    title: "Address",
                    error: hasSubmittedFormAtLeastOnce ? addressError : nil
                ) {
                    TextField("", text: $address)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(
                    title: "Zip code",
                    error: hasSubmittedFormAtLeastOnce ? zipCodeError : nil
                ) {
                    TextField("", text: $zipCode)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                /*FormElement(title: "Emergency Service Call Radius (\(Int(emergencyServiceCallRadius))mi)") {
                    Slider(value: $emergencyServiceCallRadius, in: 1...100, step: 1, minimumValueLabel: Text("1mi"), maximumValueLabel: Text("100mi")) {
                        Text("")
                    }
                }*/
                
                FormElement(
                    title: "Company description",
                    error: hasSubmittedFormAtLeastOnce ? companyDescriptionError : nil
                ) {
                    TextField("", text: $companyDescription)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Business license")
                        .font(.headline)
                    
                    if hasSubmittedFormAtLeastOnce, let documentURLError = documentURLError {
                        Text(documentURLError)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.bottom, 8)
                    }
                    
                    if let url = documentUrl {
                        Text(url.lastPathComponent)
                    }
                    
                    Button(action: pickLicense) {
                        Text("Upload")
                    }
                    .padding(4)
                }
            }
        }
        .padding(16)
        .navigationTitle("Business registration")
        .navigationBarItems(
            trailing: Button(action: submit) {
                Text("Submit")
            }
        )
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(documentUrl: $documentUrl)
        }
        .onReceive(store.$state) { state in
            switch state {
            case let .success(token):
                authenticationStore.authenticate(with: token, userType: .business)
            default:
                break
            }
        }
    }
}

extension RegistrationBusinessView {
    func pickLicense() {
        isShowingDocumentPicker = true
    }
    
    func submit() {
        hasSubmittedFormAtLeastOnce = true
        
        if formHasErrors {
            return
        }
        
        guard case let .needsRegistration(googleCredentials, googleProfileInfo) = authenticationStore.state else {
            return
        }
        
        guard let documentUrl = documentUrl else {
            return
        }
        
        store.register(
            googleCredentials: googleCredentials,
            email: googleProfileInfo.email,
            companyName: companyName,
            companyURL: companyURL,
            phoneNumber: phoneNumber,
            address: address,
            zipCode: zipCode,
            //emergencyServiceCallRadius: emergencyServiceCallRadius,
            companyDescription: companyDescription,
            documentUrl: documentUrl
        )
    }
}

struct RegistrationBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationBusinessView()
    }
}

//
//  RegistrationPersonView.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct RegistrationPersonalView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var store = RegistrationPersonalStore()
    
    @State var hasSubmittedFormAtLeastOnce = false
    
    @State var firstName = ""
    @State var lastName = ""
    @State var phoneNumber = ""
    @State var zipCode = ""
    
    var firstNameError: String? {
        if firstName.isEmpty {
            return "First name must not be empty"
        }
        
        return nil
    }
    
    var lastNameError: String? {
        if lastName.isEmpty {
            return "Last name must not be empty"
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
    
    var zipCodeError: String? {
        if zipCode.isEmpty {
            return "Zip code must not be empty"
        }
        
        if !zipCode.isValidZipCode {
            return "Zip code must in format: 00000 or 00000-0000"
        }
        
        return nil
    }
    
    var formHasErrors: Bool {
        return
            firstNameError != nil ||
            lastNameError != nil ||
            phoneNumberError != nil ||
            zipCodeError != nil
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if hasSubmittedFormAtLeastOnce && formHasErrors {
                    Text("Please correct the errors below")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.bottom, 8)
                }
                
                FormElement(
                    title: "First name",
                    error: hasSubmittedFormAtLeastOnce ? firstNameError : nil
                ) {
                    TextField("", text: $firstName)
                        .textFieldStyle(AppTextFieldStyle())
                }
                
                FormElement(
                    title: "Last name",
                    error: hasSubmittedFormAtLeastOnce ? lastNameError : nil
                ) {
                    TextField("", text: $lastName)
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
                    title: "Zip code",
                    error: hasSubmittedFormAtLeastOnce ? zipCodeError : nil
                ) {
                    TextField("", text: $zipCode)
                        .textFieldStyle(AppTextFieldStyle())
                }
            }
        }
        .padding(16)
        .navigationTitle("Personal registration")
        .navigationBarItems(
            trailing: Button(action: submit) {
                Text("Submit")
            }
        )
        .onAppear {
            switch authenticationStore.state {
            case let .needsRegistration(_, googleProfileInfo):
                firstName = googleProfileInfo.givenName ?? ""
                lastName = googleProfileInfo.familyName ?? ""
            default:
                break
            }
        }
        .onReceive(store.$state) { state in
            switch state {
            case let .success(token):
                authenticationStore.authenticate(with: token, userType: .person)
            default:
                break
            }
        }
    }
}

extension RegistrationPersonalView {
    func submit() {
        hasSubmittedFormAtLeastOnce = true
        
        if formHasErrors {
            return
        }
        
        guard case let .needsRegistration(googleCredentials, googleProfileInfo) = authenticationStore.state else {
            return
        }
        
        store.register(
            googleCredentials: googleCredentials,
            email: googleProfileInfo.email,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            zipCode: zipCode
        )
    }
}

struct RegistrationPersonalView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPersonalView()
    }
}

//
//  RegistrationView.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct RegistrationView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Please select whether you are a Business or Personal profile")
            
            Spacer()
            
            NavigationLink(destination: RegistrationBusinessView()) {
                Text("Business Profile")
            }
            .buttonStyle(AppBigButtonStyle())
            
            Text("Or")
                .font(.title)
                .foregroundColor(.blue)
                .padding([.top, .bottom], 32)
            
            NavigationLink(destination: RegistrationPersonalView()) {
                Text("Personal Profile")
            }
            .buttonStyle(AppBigButtonStyle())
            
            Spacer()
        }
        .navigationTitle("Registration")
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

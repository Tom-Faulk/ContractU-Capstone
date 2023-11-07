//
//  FormElement.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct FormElement<Content: View>: View {
    let title: String
    var error: String?
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            content()
                .padding(.horizontal, 4)
            
            if let error = error {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
        .padding(.bottom, 8)
    }
}

struct FormElement_Previews: PreviewProvider {
    static var previews: some View {
        FormElement(title: "Test") {
            TextField("", text: .constant("test"))
        }
    }
}

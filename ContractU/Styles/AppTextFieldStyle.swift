//
//  AppTextFieldStyle.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
}

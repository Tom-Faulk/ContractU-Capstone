//
//  AppBigButtonStyle.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import SwiftUI

struct AppBigButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.title)
            .foregroundColor(.blue)
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                )
                .stroke(Color.blue)
            )
    }
}

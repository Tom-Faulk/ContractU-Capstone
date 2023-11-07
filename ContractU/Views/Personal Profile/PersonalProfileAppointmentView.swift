//
//  PersonalProfileAppointmentView.swift
//  ContractU
//
//  Created by Eli Daitch on 4/17/2021.
//

import SwiftUI

struct PersonalProfileAppointmentView: View {
    let appointment: Appointment
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        return formatter.string(from: appointment.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(appointment.title)
                .font(.headline)
            
            Text("\(formattedDate)")
            
            Text(appointment.business.companyName)
            
            Text(appointment.description)
        }
        .padding()
    }
}

struct PersonalProfileAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileAppointmentView(
            appointment: Appointment(
                id: 1,
                title: "Post",
                description: "A nice post",
                date: Date(),
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
        )
    }
}

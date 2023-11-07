//
//  BusinessDetailView.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import MapKit
import SwiftUI

struct BusinessDetailView: View {
    let business: Business
    
    @State var location: BusinessLocation? = nil
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.16607480, longitude: -86.52664720),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )
    
    @State var isBookAppointmentPresented = false
    
    var body: some View {
        ScrollView {
            VStack {
                Map(
                    coordinateRegion: $region,
                    annotationItems: [location].compactMap { $0 }
                ) { item in
                    MapPin(coordinate: item.placemark.coordinate)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)
            
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name")
                            .frame(width: 120, alignment: .leading)
                        
                        Spacer()
                        
                        Text(business.companyName)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Website")
                            .frame(width: 120, alignment: .leading)
                        
                        Spacer()
                        
                        Button(action: openURL) {
                            Text(business.companyUrl)
                                .fontWeight(.bold)
                        }
                    }
                    
                    HStack {
                        Text("Phone number")
                            .frame(width: 120, alignment: .leading)
                        
                        Spacer()
                        
                        Text(business.phoneNumber)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Address")
                            .frame(width: 120, alignment: .leading)
                        
                        Spacer()
                        
                        Text(business.address)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("ZIP code")
                            .frame(width: 120, alignment: .leading)
                        
                        Spacer()
                        
                        Text(business.zipCode)
                            .fontWeight(.bold)
                    }
                    
                    Text(business.companyDescription)
                        .padding(.top, 16)
                }
                .padding()
            }
        }
        .navigationTitle(Text(business.companyName))
        .navigationBarItems(trailing: Button(action: bookAppointment) {
            Text("Book appointment")
        })
        .sheet(isPresented: $isBookAppointmentPresented) {
            NavigationView {
                BookAppointmentView(business: business)
            }
        }
        .onAppear {
            let address = "\(business.companyName), \(business.address), \(business.zipCode)"
            
            let geoCoder = CLGeocoder()

            geoCoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    print(error)

                    return
                }

                guard let location = placemarks?.first?.location else {
                    print("No results found")

                    return
                }

                self.location = BusinessLocation(
                    placemark: MKPlacemark(coordinate: location.coordinate)
                )
                
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: 1000,
                    longitudinalMeters: 1000
                )
            }
        }
    }
}

extension BusinessDetailView {
    func openURL() {
        guard
            let url = URL(string: business.companyUrl),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func bookAppointment() {
        isBookAppointmentPresented = true
    }
}

struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessProfileView()
    }
}

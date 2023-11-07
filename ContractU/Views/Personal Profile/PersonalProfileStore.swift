//
//  PersonalProfileStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/31/21.
//

import Combine
import Foundation

class PersonalProfileStore: ObservableObject {
    enum ProfileState {
        case ready
        case loading
        case success(person: Person)
        case failed(error: Error)
    }
    
    enum AppointmentsState {
        case ready
        case loading
        case success(appointments: [Appointment])
        case failed(error: Error)
    }
    
    @Published var profileState: ProfileState = .ready {
        didSet {
            print(profileState)
        }
    }
    
    @Published var appointmentsState: AppointmentsState = .ready {
        didSet {
            print(profileState)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        fetchProfile()
        fetchAppointments()
    }
    
    func fetchProfile() {
        profileState = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/person/v1/profile.php")!
        let request = URLRequest(url: url)

        return APIService.shared.request(request)
            .map { (person: Person) in
                .success(person: person)
            }
            .catch { error in
                Just(.failed(error: error))
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.profileState, on: self)
            .store(in: &cancellables)
    }

    func fetchAppointments() {
        appointmentsState = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/appointment/v1/my-appointments.php")!
        let request = URLRequest(url: url)

        return APIService.shared.request(request)
            .map { (appointments: [Appointment]) in
                .success(appointments: appointments)
            }
            .catch { error in
                Just(.failed(error: error))
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.appointmentsState, on: self)
            .store(in: &cancellables)
    }
}

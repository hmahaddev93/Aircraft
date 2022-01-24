//
//  AircraftsViewModel.swift
//  Aircraft
//
//  Created by Khateeb H. on 1/23/22.
//

import SwiftUI
import Combine

final class AircraftsViewModel: ObservableObject {
    @Published var aircrafts:[Aircraft] = [Aircraft]()
    @Published var activeError: Error?
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(
            get: {
            return self.activeError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.activeError = nil
        })
    }
        
    func fetchAircrafts() {
        AircraftService.shared.getAircrafts { [unowned self] result in
            switch result {
                
            case .success(let items):
                DispatchQueue.main.async {
                    self.aircrafts = items
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.activeError = error
                    self.aircrafts = []
                }
            }
        }
    }
}


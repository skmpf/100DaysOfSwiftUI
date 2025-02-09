//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Sebastien KEMPF on 09/02/2025.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        var isUnlocked = false
        var isBiometricsUnavailablePresented = false
        var isAuthenticationFailedPresented = false
        var selectedMode = "Standard"
        var modes = ["Standard", "Hybrid"]
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(
                id: UUID(),
                name: "Example location",
                description: "Example description",
                latitude: point.latitude,
                longitude: point.longitude
            )
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return}
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: &error
            ) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                ) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.isUnlocked = true
                        }
                        else {
                            self.isAuthenticationFailedPresented = true
                        }
                    }
                }
            } else {
                isBiometricsUnavailablePresented = true
            }
        }
    }
}

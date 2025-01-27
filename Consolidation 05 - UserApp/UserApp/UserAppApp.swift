//
//  UserAppApp.swift
//  UserApp
//
//  Created by Sebastien KEMPF on 25/01/2025.
//

import SwiftData
import SwiftUI

@main
struct UserAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}

//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Sebastien KEMPF on 17/01/2025.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}

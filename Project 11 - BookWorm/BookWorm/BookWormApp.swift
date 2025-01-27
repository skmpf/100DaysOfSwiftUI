//
//  BookWormApp.swift
//  BookWorm
//
//  Created by Sebastien KEMPF on 10/01/2025.
//

import SwiftData
import SwiftUI

@main
struct BookWormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}

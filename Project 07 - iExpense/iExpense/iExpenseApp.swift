//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Sébastien Kempf on 22/12/2024.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}

//
//  AddActivityView.swift
//  HabitTracking
//
//  Created by Sebastien KEMPF on 12/01/2025.
//

import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    
    var activities: Activities
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationTitle("Add activity")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newActivity = Activity(title: title, description: description, count: 1)
                        activities.items.append(newActivity)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add activity")
        }
    }
}

#Preview {
    AddActivityView(activities: Activities())
}

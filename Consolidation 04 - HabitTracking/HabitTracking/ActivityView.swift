//
//  ActivityView.swift
//  HabitTracking
//
//  Created by Sebastien KEMPF on 13/01/2025.
//

import SwiftUI

struct ActivityView: View {
    let activity: Activity
    @Bindable var activities: Activities
    
    var currentActivity: Activity {
        if let index = activities.items.firstIndex(of: activity) {
            return activities.items[index]
        }
        return activity
    }
        
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(activity.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Count: \(currentActivity.count)")
                    .font(.headline)
                
                Button("Increment count") {
                    if let index = activities.items.firstIndex(of: activity) {
                        let newActivity = Activity(
                            title: activity.title,
                            description: activity.description,
                            count: activities.items[index].count + 1
                        )
                        activities.items[index] = newActivity
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(activity.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    ActivityView(activity: Activity(title: "Nice title", description: "Short description of the activity", count: 1), activities: Activities())
}

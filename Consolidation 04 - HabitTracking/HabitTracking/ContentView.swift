//
//  ContentView.swift
//  HabitTracking
//
//  Created by Sebastien KEMPF on 12/01/2025.
//

import SwiftUI

struct Activity: Hashable, Codable, Identifiable, Equatable {
    var id = UUID()
    let title: String
    let description: String
    var count: Int
}

@Observable
class Activities {
    var items = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let savedActivities = UserDefaults.standard.data(forKey: "Activities") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: savedActivities) {
                items = decoded
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var activities = UserDefaults.standard.object(forKey: "Activities") as? Activities ?? Activities()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities.items, id: \.id) { activity in
                    NavigationLink {
                        ActivityView(activity: activity, activities: activities)
                    } label: {
                        Text(activity.title)
                    }
                }
                .onDelete { indexSet in
                    activities.items.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Habit Tracking")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Label("Add activity", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingSheet) {
                AddActivityView(activities: activities)
            }
        }
    }
}

#Preview {
    ContentView()
}

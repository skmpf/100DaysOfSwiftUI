//
//  ContentView.swift
//  UserApp
//
//  Created by Sebastien KEMPF on 25/01/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \User.name) var users: [User]
    
    var body: some View {
        NavigationStack {
            List(users, id: \.id) { user in
                NavigationLink {
                    UserView(user: user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.isActive ? "Active" : "Inactive")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Users")
            .task {
                if users.isEmpty {
                    await fetchAndSaveData()
                }
            }
        }
    }
    
    private func fetchAndSaveData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let decodedUsers = try? decoder.decode([User].self, from: data) {
                for decodedUser in decodedUsers {
                    modelContext.insert(decodedUser)
                }
                
                try modelContext.save()
                print("Data saved successfully")
            }
        } catch {
            print("Error fetch or saving data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}

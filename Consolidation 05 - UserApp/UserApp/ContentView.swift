//
//  ContentView.swift
//  UserApp
//
//  Created by Sebastien KEMPF on 25/01/2025.
//

import SwiftData
import SwiftUI

@Model
class User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case isActive
        case name
        case age
        case company
        case email
        case address
        case about
        case registered
        case tags
        case friends
    }
    
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    @Relationship var friends: [Friend]
    
    init(id: String, isActive: Bool, name: String, age: Int, company: String, email: String, address: String, about: String, registered: Date, tags: [String], friends: [Friend]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.company = try container.decode(String.self, forKey: .company)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        self.about = try container.decode(String.self, forKey: .about)
        self.registered = try container.decode(Date.self, forKey: .registered)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.friends = try container.decode([Friend].self, forKey: .friends)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encode(about, forKey: .about)
        try container.encode(registered, forKey: .registered)
        try container.encode(tags, forKey: .tags)
        try container.encode(friends, forKey: .friends)
    }
}

@Model
class Friend: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = id
        self.name = name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    
    var body: some View {
        NavigationStack {
            if users.isEmpty {
                ProgressView("Loading Uers...")
                    .task {
                        await fetchAndSaveData()
                    }
            } else {
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
                    if users.contains(where: { $0.id == decodedUser.id }) == false {
                        let newUser = User(
                            id: decodedUser.id,
                            isActive: decodedUser.isActive,
                            name: decodedUser.name,
                            age: decodedUser.age,
                            company: decodedUser.company,
                            email: decodedUser.email,
                            address: decodedUser.address,
                            about: decodedUser.about,
                            registered: decodedUser.registered,
                            tags: decodedUser.tags,
                            friends: []
                        )
                        
                        for decodedFriend in decodedUser.friends {
                            let newFriend = Friend(id: decodedFriend.id, name: decodedFriend.name)
                            newUser.friends.append(newFriend)
                        }
                        
                        modelContext.insert(newUser)
                    }
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

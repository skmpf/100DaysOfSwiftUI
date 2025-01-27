//
//  ListLayout.swift
//  Moonshot
//
//  Created by Sébastien Kempf on 04/01/2025.
//

import SwiftUI

struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]

    var body: some View {
        List {
            ForEach(missions) { mission in
                NavigationLink(value: mission) {
                    HStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding()
                        
                        HStack {
                            Text(mission.displayName)
                                .font(.headline)
                            Spacer()
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                        }
                    }
                }
                .padding([.leading, .trailing])
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 3, leading: 15, bottom: 3, trailing: 15))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.lightBackground)
                                )
            }
        }
        .navigationDestination(for: Mission.self) { mission in
            MissionView(mission: mission, astronauts: astronauts)
        }
        .listStyle(.plain)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    ListLayout(astronauts: astronauts, missions: missions)
        .preferredColorScheme(.dark)
}

//
//  ContentView.swift
//  Moonshot
//
//  Created by Sebastien KEMPF on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showingGrid = true
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if showingGrid {
                    GridLayout(astronauts: astronauts, missions: missions)
                } else {
                    ListLayout(astronauts: astronauts, missions: missions)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(showingGrid ? "List view" : "Grid view") {
                    showingGrid.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

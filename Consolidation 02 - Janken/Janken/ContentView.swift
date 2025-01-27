//
//  ContentView.swift
//  Janken
//
//  Created by Sebastien KEMPF on 12/12/2024.
//

import SwiftUI

private let choices: [String] = ["rock", "paper", "scissors"]

struct ContentView: View {
    @State private var gameCurrentChoice: String = choices.randomElement()!
    @State private var userShouldWin: Bool = Bool.random()
    @State private var score: Int = 0
    @State private var round: Int = 1
    @State private var showingGameOver: Bool = false
    
    func emoji(for choice: String) -> String {
        switch choice {
        case "rock": return "✊"
        case "paper": return "🖐"
        case "scissors": return "✌️"
        default: return ""
        }
    }
    func winningMove(against: String) -> String {
        let index = choices.firstIndex(of: against)!
        if userShouldWin {
            return index == choices.count - 1 ? choices[0] : choices[index + 1]
        } else {
            return index == 0 ? choices[choices.count - 1] : choices[index - 1]
        }
    }
    func handleUserChoice(choice: String) {
        if choice == winningMove(against: gameCurrentChoice) {
            score += 1
        } else {
            score -= 1
        }
        if round == 10 {
            showingGameOver = true
        } else {
            round += 1
        }
        gameCurrentChoice = choices.randomElement()!
        userShouldWin.toggle()
    }
    func restartGame() {
        gameCurrentChoice = choices.randomElement()!
        userShouldWin.toggle()
        score = 0
        round = 1
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.purple,                  Color.blue]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                VStack {
                    Text("Rock Paper Scissors")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Round \(round) of 10")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack {
                    Text("\(userShouldWin ? "Win" : "Lose") this round against")
                    Text("\(emoji(for :gameCurrentChoice))")
                        .font(.system(size: 50))
                }
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(userShouldWin ? .green : .red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.7))
                )
                
                Spacer()
                
                HStack(spacing: 20) {
                    ForEach(choices, id: \.self) { choice in
                        Button {
                            handleUserChoice(choice: choice)
                        } label: {
                            Text("\(emoji(for: choice))")
                                .font(.largeTitle)
                                .frame(width: 80, height: 80)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                }
            }
            .padding()
        }
        .alert("Game over! Your final score is \(score)", isPresented: $showingGameOver) {
            Button("Restart", action: restartGame)
        }
    }
}

#Preview {
    ContentView()
}

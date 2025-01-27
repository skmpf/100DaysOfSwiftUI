//
//  ContentView.swift
//  MTables
//
//  Created by Sébastien Kempf on 21/12/2024.
//

import SwiftUI

struct Question {
    let question: String
    let answer: Int
}

struct ContentView: View {
    @State private var gameIsActive = false
    @State private var table = 2
    @State private var numOfQuestions = 10
    @State private var round = 0
    @State private var answer = ""
    @State private var questions = [Question]()
    @State private var correctAnswers = 0
    @State private var showScore = false
    
    func StartGame() {
        gameIsActive = true
        for _ in 1...numOfQuestions {
            let number = Int.random(in: 1...10)
            let question = Question(question: "What is \(table) x \(number)?", answer: table * number)
            questions.append(question)
        }
        round += 1
    }
    
    func EndGame() {
        gameIsActive = false
        showScore = true
        questions.removeAll()
        round = 0
    }
    
    func NextQuestion() {
        if answer == String(questions[round].answer) {
            correctAnswers += 1
        }
        if round == numOfQuestions - 1 {
            EndGame()
        } else {
            round += 1
            answer = ""
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                if !gameIsActive {
                    Stepper("Table of \(table)", value: $table, in: 2...12)
                    Picker("Number of questions", selection: $numOfQuestions) {
                        ForEach([5 ,10, 20], id: \.self) {
                            Text("\($0)")
                        }
                    }
                } else {
                    Text(gameIsActive ? questions[round].question : "Get ready for next question")
                    TextField("Answer", text: $answer)
                        .keyboardType(.numberPad)
                        .onSubmit {
                            NextQuestion()
                        }
                }
            }
            .navigationTitle("MTables")
            .navigationBarItems(trailing: Button(gameIsActive ? "End Game" : "Start Game", action: gameIsActive ? EndGame : StartGame))
            .alert("Game over, your score is \(correctAnswers)", isPresented: $showScore) {
                Button("OK", role: .cancel) {
                    showScore = false
                    correctAnswers = 0
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

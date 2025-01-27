//
//  AddBookView.swift
//  BookWorm
//
//  Created by Sebastien KEMPF on 11/01/2025.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 3
    @State private var date = Date.now
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Name of author", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        let book = Book(title: title, author: author, genre: genre, review: review, rating: rating, date: date)
                        modelContext.insert(book)
                        dismiss()
                    }
                    .disabled(validateInputs == false)
                }
            }
            .navigationTitle("Add Book")
        }
    }
    
    var validateInputs: Bool {
        if title.isEmpty || author.isEmpty || review.isEmpty {
            return false
        }
        return true
    }
}

#Preview {
    AddBookView()
}

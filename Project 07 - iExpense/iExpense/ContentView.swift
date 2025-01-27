//
//  ContentView.swift
//  iExpense
//
//  Created by Sébastien Kempf on 22/12/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var sortOrder = [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.type)
    ]
    @State private var type = "All"
    @Query var expenses: [Expense]
    
    private let types = ["All", "Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            List{
                ExpensesView(type: type, sortOrder: sortOrder, onDelete: deleteExpenses)
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        AddView()
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .automatic) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([SortDescriptor(\Expense.name), SortDescriptor(\Expense.type)])
                            
                            Text("Sort by Amount")
                                .tag([SortDescriptor(\Expense.amount), SortDescriptor(\Expense.type)])
                        }
                    }
                }
                
                ToolbarItem(placement: .automatic) {
                    Menu("Filter", systemImage: "line.3.horizontal.decrease") {
                        Picker("Filter", selection: $type) {
                            ForEach(types, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteExpenses(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(expenses[offset])
        }
    }
}

#Preview {
    ContentView()
}

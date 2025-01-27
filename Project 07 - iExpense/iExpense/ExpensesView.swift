//
//  ExpensesView.swift
//  iExpense
//
//  Created by Sebastien KEMPF on 24/01/2025.
//

import SwiftData
import SwiftUI

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        ForEach(expenses) { expense in
            HStack {
                VStack(alignment: .leading) {
                    Text(expense.name)
                        .font(.headline)
                    
                    Text(expense.type)
                }
                
                Spacer()
                
                Text(expense.amount,format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .foregroundStyle(expense.amount < 100 ? .green : .red)
            }
        }
        .onDelete(perform: onDelete)
    }
    
    init(type: String, sortOrder: [SortDescriptor<Expense>], onDelete: @escaping (IndexSet) -> Void) {
        _expenses = Query(filter: #Predicate<Expense> { expense in
            if type == "All" {
                return true
            } else {
                return expense.type == type
            }
        }, sort: sortOrder)
        
        self.onDelete = onDelete
    }
}

#Preview {
    func onDelete(indexSet: IndexSet) { }
    return ExpensesView(type: "Personal", sortOrder: [SortDescriptor(\Expense.name)], onDelete: onDelete)
        .modelContainer(for: Expense.self)
}

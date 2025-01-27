//
//  ContentView.swift
//  UnitBot
//
//  Created by Sebastien KEMPF on 08/12/2024.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var baseAmount = 0.0
    @State private var baseUnit = "m"
    @State private var targetUnit = "ft"
    
    let units = ["mm", "cm", "m", "km", "ft", "yd", "mi"]
    var baseAmountInMeters: Double {
        switch baseUnit {
            case "mm": return baseAmount / 1000
            case "cm": return baseAmount / 100
            case "m": return baseAmount
            case "km": return baseAmount * 1000
            case "ft": return baseAmount * 0.3047999902
            case "yd": return baseAmount * 0.9144027578
            case "mi": return baseAmount * 1609.34708789
            default: return 0
        }
    }
    var targetAmount: Double {
        switch targetUnit {
            case "mm": return baseAmountInMeters * 1000
            case "cm": return baseAmountInMeters * 100
            case "m": return baseAmountInMeters
            case "km": return baseAmountInMeters / 1000
            case "ft": return baseAmountInMeters / 0.3047999902
            case "yd": return baseAmountInMeters / 0.9144027578
            case "mi": return baseAmountInMeters / 1609.34708789
            default: return 0
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Base unit") {
                    Picker("Base unit", selection: $baseUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Target unit") {
                    Picker("Target unit", selection: $targetUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                            
                }

                Section("Amount to convert") {
                    TextField("Amount", value: $baseAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                
                Section("Result") {
                    Text(targetAmount.formatted(.number))
                }
            }
            .navigationTitle("UnitBot")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Sebastien KEMPF on 07/01/2025.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.address)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zipCode)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                        .onAppear {
                            let addressItems = [
                                order.name,
                                order.address,
                                order.city,
                                order.zipCode
                            ]
                            if let encoded = try? JSONEncoder().encode(addressItems) {
                                UserDefaults.standard.set(encoded, forKey: "Address")
                            }
                        }
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}

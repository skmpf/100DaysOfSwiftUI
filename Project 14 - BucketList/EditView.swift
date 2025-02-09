//
//  EditView.swift
//  BucketList
//
//  Created by Sebastien KEMPF on 09/02/2025.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
        .task {
            await viewModel.fetchNearbyPlaces()
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        _viewModel = State(wrappedValue: ViewModel(location: location))
        self.onSave = onSave
        
    }
    
    
}

#Preview {
    EditView(location: .example) { _ in }
}

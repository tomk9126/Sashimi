//
//  CarnivalToolbar.swift
//  Sashimi
//
//  Created by Tom Keir on 28/5/2024.
//

import SwiftUI

struct CarnivalToolbar: View {
    @Binding var showingNewCarnivalSheet: Bool
    
	@State private var openError: String?
	@State private var didError = false
	
    var body: some View {
        Spacer() // To align menu to the right
        Menu {
            Button("Sample Data") {
                CarnivalManager.shared.exampleUsage()
            }
            .help("Create sample carnival with events and athletes for demonstration.")
            
			Button("New Carnival", systemImage: "plus") { showingNewCarnivalSheet.toggle() }
                // NewCarnival sheet is found in ContentView
                .help("Create a new carnival")
            
			Button("Open Carnival", systemImage: "folder") {
                CarnivalManager.shared.loadCarnival { error in
					if let error = error {
						openError = error.localizedDescription
						didError = true
					}
                }
            }
			.help("Open an already existing carnival")
			
        } label: {
            Label("Add Carnival", systemImage: "plus")
        }
		.alert(isPresented: $didError) {
			Alert(title: Text("Failed to open Carnival"), message: Text(openError ?? "An unknown error occured"))
		}
    }
}
#Preview {
    ContentView()
        .environmentObject(CarnivalManager.shared)
}

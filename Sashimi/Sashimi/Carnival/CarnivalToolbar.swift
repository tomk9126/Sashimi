//
//  CarnivalToolbar.swift
//  Sashimi
//
//  Created by Tom Keir on 28/5/2024.
//

import SwiftUI

struct CarnivalToolbar: View {
    @Binding var showingNewCarnivalSheet: Bool
    
    var body: some View {
        Spacer()
        Menu {
            Button("Sample Data") {
                CarnivalManager.shared.exampleUsage()
            }
            .help("Create sample carnival with events and athletes for demonstration.")
            Button("New Carnival", systemImage: "plus") { showingNewCarnivalSheet.toggle() }
                .help("Create a new carnival")
            Button("Open Carnival", systemImage: "folder") {
                CarnivalManager.shared.loadCarnival { error in
                    if let error = error {
                        //self.importErrors.append(error.localizedDescription)
                        //self.showImportAlert = true
                    }
                }
            }
                .help("Open an already existing carnival")
        } label: {
            Label("Add Carnival", systemImage: "plus")
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(CarnivalManager.shared)
}

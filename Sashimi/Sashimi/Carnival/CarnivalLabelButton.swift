//
//  CarnivalLabelButton.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalLabelButton: View {
    
    @State private var showingDeletionAlert = false
    @State private var document: CarnivalFile?
    @State private var isExporting = false
    @State private var closeAfterSaving = false
    
    var carnival: Carnival
    
    var body: some View {
        HStack {
            Image("Swordfish")
                .resizable()
                .scaledToFit()
                //.frame(width: 25)
                .opacity(0.5)
                
            VStack (alignment: .leading) {
                Text(carnival.name)
                    .font(.headline)
                Text(carnival.date, format: .dateTime.day().month().year())
                   
            }
            Spacer()
            Button("Close Carnival", systemImage: "xmark") {
                showingDeletionAlert.toggle()
            }.labelStyle(.iconOnly)
                .help("Close the Carnival.")
        }
        .frame(height: 40)
        .contextMenu(ContextMenu(menuItems: {
            Button("Close Carnival", systemImage: "bin", role: .destructive) {
                showingDeletionAlert.toggle()
            }
            Button("Save Carnival", systemImage: "file") {
                document = CarnivalFile(carnival: carnival)
                isExporting.toggle()
            }
        }))
        .alert(
                "Unsaved Changes",
                isPresented: $showingDeletionAlert
            ) {
                Button("Save and Close") {
                    closeAfterSaving = true
                    document = CarnivalFile(carnival: carnival)
                    isExporting.toggle()
                }
                Button("Close Carnival", role: .destructive) {
                    CarnivalManager.shared.deleteCarnival(carnival)
                }
            } message: {
                Text("You will lose these unsaved changes permanently")
        }
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: .json,
            defaultFilename: carnival.name
        ) { result in
            if closeAfterSaving {
                CarnivalManager.shared.deleteCarnival(carnival)
            }
            if case .failure(let error) = result {
                print("Failed to export carnival: \(error)")
            }
        }
    }
}

#Preview {
    CarnivalManager.shared.exampleUsage()
    return ContentView()
}

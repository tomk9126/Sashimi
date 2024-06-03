//
//  CarnivalSettings.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct CarnivalSettings: View {
    @Binding var carnival: Carnival
    
    var body: some View {
        VStack {
            Text("Carnival Settings")
                .font(.headline)
            Form {
                TextField(text: $carnival.name, prompt: Text("Example: 'BHC Swimming Carnival'")) {
                    Text("Name:")
                }
                DatePicker(
                    "Date:",
                    selection: $carnival.date,
                    displayedComponents: [.date]
                )
                
                LabeledContent("Where:") {
                    VStack(alignment: .leading) {
                        Button(carnival.fileURL == nil ? "Choose Location" : "Change Location", systemImage: "folder") {
                            saveLocationPanel()
                        }
                        Text(carnival.fileURL?.path ?? "This carnival is not saved. You may continue, but you can lose unsaved data.")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
    
    func saveLocationPanel() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.carnival]
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = "\(carnival.name).carnival"

        panel.begin { response in
            guard response == .OK, let url = panel.url else {
                return
            }
            do {
                let fileManager = FileManager.default
                let newFileURL = url
                if let currentFileURL = carnival.fileURL {
                    // Move the existing file to the new location
                    try fileManager.moveItem(at: currentFileURL, to: newFileURL)
                } else {
                    // If there is no existing file, create a new one at the new location
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .iso8601
                    let data = try encoder.encode(carnival)
                    try data.write(to: newFileURL)
                }
                // Update the carnival's file URL
                carnival.fileURL = newFileURL
            } catch {
                print("Failed to move carnival file: \(error)")
            }
        }
    }
}

#Preview {
    @State var newCarnival = Carnival(name: "", date: Date.now)
    return CarnivalSettings(carnival: $newCarnival).padding()
}

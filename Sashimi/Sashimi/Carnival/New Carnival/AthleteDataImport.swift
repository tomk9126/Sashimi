//
//  AthleteDataImport.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct HelpButton: View {
    var action : () -> Void

    var body: some View {
        Button(action: action, label: {
            ZStack {
                Circle()
                    .strokeBorder(Color(NSColor.controlShadowColor), lineWidth: 0.5)
                    .background(Circle().foregroundColor(Color(NSColor.controlColor)))
                    .shadow(color: Color(NSColor.controlShadowColor).opacity(0.3), radius: 1)
                    .frame(width: 20, height: 20)
                Text("?").font(.system(size: 15, weight: .medium))
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct GradientButton: View {
    var glyph: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: glyph)
                    .fontWeight(.medium)
                Color.clear
                    .frame(width: 24, height: 24)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct AthleteDataImport: View {
    @State private var isImporting = false
    @Binding var newAthletes: [Athlete]
    @State private var selection: Athlete.ID?
    
    
    var body: some View {
        VStack {
            Form {
                Table($newAthletes, selection: $selection) {
                    TableColumn("First Name") { $athlete in
                        TextField("", text: $athlete.athleteFirstName)
                    }
                    TableColumn("Last Name") { $athlete in
                        TextField("", text: $athlete.athleteLastName)
                    }
                    TableColumn("DOB") { $athlete in
                        TextField("", text: $athlete.athleteDOB)
                    }
                }
                .tableStyle(.bordered)
                .padding(.bottom, 24)
                .overlay(alignment: .bottom, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Divider()
                        HStack(spacing: 0) {
                            GradientButton(glyph: "plus") {
                                let newAthlete = Athlete(athleteFirstName: "First", athleteLastName: "Last", athleteDOB: "DOB")
                                newAthletes.append(newAthlete)
                                selection = newAthlete.id // Update selection to the new athlete
                            }
                            .keyboardShortcut(.defaultAction) // Set default action (Enter key)
                            .padding(.trailing, 8)
                            
                            GradientButton(glyph: "minus") {
                                // Remove selected athletes
                                if let selectedAthleteId = selection {
                                    newAthletes.removeAll { $0.id == selectedAthleteId }
                                    selection = nil // Clear selection after removing athlete
                                }
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                    .background(
                        Rectangle()
                            .stroke()
                            .opacity(0.04)
                    )
                })
            }
            HStack {
                Button("Import from Database (.csv)", role: .cancel) {
                    isImporting.toggle()
                }
                HelpButton {
                    
                }
                Spacer()
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.commaSeparatedText],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let files):
                files.forEach { file in
                    // Gain access to the directory
                    let gotAccess = file.startAccessingSecurityScopedResource()
                    defer {
                        // Release access
                        file.stopAccessingSecurityScopedResource()
                    }
                    guard gotAccess else { return }
                    do {
                        let data = try Data(contentsOf: file)
                        guard let content = String(data: data, encoding: .utf8) else {
                            print("Failed to decode CSV data.")
                            return
                        }
                        let rows = content.components(separatedBy: .newlines)
                        for row in rows {
                            let columns = row.components(separatedBy: ",")
                            if columns.count == 3 {
                                let newAthlete = Athlete(athleteFirstName: columns[0], athleteLastName: columns[1], athleteDOB: columns[2])
                                newAthletes.append(newAthlete)
                            }
                        }
                    } catch {
                        print("Error reading file: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                // Handle error
                print("File importing failed with error: \(error.localizedDescription)")
            }
        }
    }
}
//#Preview {
    //AthleteDataImport(newAthletes: [Athlete])
    //    .padding()
//}

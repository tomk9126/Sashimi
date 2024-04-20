//
//  AthleteDataImport.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct GradientButton: View {
    var glyph: String
    var body: some View {
        ZStack {
            Image(systemName: glyph)
                .fontWeight(.medium)
            Color.clear
                .frame(width: 24, height: 24)
        }
    }
}

struct AthleteDataImport: View {
    
    @State private var isImporting = false
    @State private var selectedDatabase = "file://"
    
    @State var newAthletes: [Athlete] = [] // Define athletes array
    @State var selection = Set<Athlete.ID>()
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
                            Button(action: {newAthletes.append(Athlete(athleteFirstName: "John", athleteLastName: "Smith", athleteDOB: ""))}) {
                                GradientButton(glyph: "plus")
                            }
                            Divider().frame(height: 16)
                            Button(action: {}) {
                                GradientButton(glyph: "minus")
                            }
                            //.disabled(selection == nil ? true : false)
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
                Button("Import (.csv)", role: .cancel) {
                    isImporting.toggle()
                }
                Text(selectedDatabase)
                Spacer()
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.commaSeparatedText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                print(selectedFile)
                selectedDatabase = selectedFile.absoluteString

            } catch {
                // Handle failure.
            }
        }
    }
}


#Preview {
    AthleteDataImport()
        .padding()
}

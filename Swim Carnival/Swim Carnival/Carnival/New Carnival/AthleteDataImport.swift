//
//  AthleteDataImport.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct AthleteDataImport: View {
    
    @State private var isImporting = false
    @State private var selectedDatabase = "file://"
    
    var body: some View {
        VStack {
            Section("Link to Athletes Database") {
                Table(Carnival(name: "Summer Carnival").athletes) {
                            TableColumn("Name", value: \.athleteFirstName)
                            TableColumn("Surname", value: \.athleteLastName)
                            TableColumn("DOB", value: \.athleteDOB)
                }.tableStyle(.bordered)
                HStack {
                    Button("Import (.csv)", role: .cancel) {
                        isImporting.toggle()
                    }
                    Text(selectedDatabase)
                    Spacer()
                }
                
            }
        }
        .frame(width: 500, height: 280)
        
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
}

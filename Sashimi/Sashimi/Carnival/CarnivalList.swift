//
//  CarnivalList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct CarnivalList: View {

    @ObservedObject var carnivalManagerObserved = CarnivalManager.shared

    @State private var showingNewCarnivalSheet = false
    @State private var document: CarnivalFile?
    @State private var isImporting: Bool = false

    @State private var selectedCarnival: Carnival?
    @State private var importErrors: [String] = []
    
    @State var showImportAlert = false
    
    var body: some View {

        NavigationStack {
            if carnivalManagerObserved.carnivals.isEmpty {
                VStack {
                    Text("No Carnivals.")
                }.padding()

            } else {
                List {
                    ForEach(carnivalManagerObserved.carnivals, id: \.self) { carnival in
                        NavigationLink(destination: CarnivalView(carnival: carnival)) {
                            CarnivalLabelButton(carnival: carnival)
                        }
                    }
                }.id(UUID())
            }
        }
        .toolbar {
            ToolbarItemGroup() {
                Spacer()
                Menu {
                    Button("Sample Data") {
                        CarnivalManager.shared.exampleUsage()
                    }
                    .help("Create sample carnival with events and athletes for demonstration.")
                    Button("New Carnival", systemImage: "plus") { showingNewCarnivalSheet.toggle() }
                        .help("Create a new carnival")
                    Button("Open Carnival", systemImage: "folder") { isImporting.toggle() }
                        .help("Open an already existing carnival")
                } label: {
                    Label("Add Carnival", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewCarnivalSheet) {
            NewCarnival()
                .padding()
        }
        .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [.json],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        importErrors = []
                        guard let selectedFile = try result.get().first else { return }
                        let data = try Data(contentsOf: selectedFile)
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let importedCarnival = try decoder.decode(Carnival.self, from: data)

                        // Check if the carnival with the same id already exists
                        if !CarnivalManager.shared.carnivals.contains(where: { $0.id == importedCarnival.id }) {
                            CarnivalManager.shared.carnivals.append(importedCarnival)
                        } else {
                            print("Carnival with the same ID already exists.")
                            importErrors.append("Carnival is already open.")
                        }
                    } catch {
                        print("Failed to import carnival: \(error)")
                        importErrors.append("\(error)")
                    }
                    if !importErrors.isEmpty {
                        showImportAlert = true
                    }
                }
        
        .onAppear {
            if carnivalManagerObserved.carnivals.count > 0 {
                selectedCarnival = carnivalManagerObserved.carnivals.first
            }
        }
        .alert(isPresented: $showImportAlert) {
            Alert(
                title: Text("Import Error"),
                message: Text(importErrors.joined(separator: "\n")),
                dismissButton: .default(Text("OK")) {
                    importErrors.removeAll()
                }
            )
            
            
        }
    }
}

#Preview {
    
    return CarnivalList()
}

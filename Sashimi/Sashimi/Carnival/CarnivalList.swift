//
//  CarnivalList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers
import AppKit

struct CarnivalList: View {
    @EnvironmentObject var carnivalManager: CarnivalManager

    @State private var showingNewCarnivalSheet = false
    @State private var isImporting: Bool = false
    @State private var importErrors: [String] = []
    @State private var showImportAlert = false

    var body: some View {
        NavigationSplitView {
            if carnivalManager.carnivals.isEmpty {
                VStack {
                    Text("No Carnivals.")
                }.padding()
                .toolbar {
                    ToolbarItemGroup() {
                        CarnivalToolbar(showingNewCarnivalSheet: $showingNewCarnivalSheet)
                    }
                }
            } else {
                List($carnivalManager.carnivals, selection: $carnivalManager.selectedCarnival) { $carnival in
                    NavigationLink(destination: CarnivalView(carnival: $carnival)) {
                        CarnivalLabelButton(carnival: $carnival)
                    }
                }
                .toolbar {
                    ToolbarItemGroup() {
                        CarnivalToolbar(showingNewCarnivalSheet: $showingNewCarnivalSheet)
                    }
                }
            }
        } detail: {
            NoCarnivalSelected()
            // This is the default detail view, but is overridden once a carnival is selected in CarnivalList()
        }
        .frame(minWidth: 205)
        .sheet(isPresented: $showingNewCarnivalSheet) {
            NewCarnival()
                .padding()
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


struct CarnivalFile: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    var carnival: Carnival
    
    init(carnival: Carnival) {
        self.carnival = carnival
    }
    
    init(configuration: ReadConfiguration) throws {
        let data = try configuration.file.regularFileContents ?? Data()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.carnival = try decoder.decode(Carnival.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(carnival)
        return .init(regularFileWithContents: data)
    }
}

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

//#Preview {
//    CarnivalManager.shared.exampleUsage()
//    @State var currentCarnival: Carnival? = nil
//    return ContentView(currentCarnival: $currentCarnival)
//}

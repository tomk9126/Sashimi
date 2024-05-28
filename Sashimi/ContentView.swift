//
//  ContentView.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers
import AppKit

struct ContentView: View {
    @EnvironmentObject var carnivalManager: CarnivalManager
    
    @State private var showingNewCarnivalSheet = false
    
    @State private var isImporting: Bool = false
    @State private var importErrors: [String] = []
    @State private var showImportAlert = false
    
    var body: some View {
        NavigationSplitView {
            CarnivalList(showingNewCarnivalSheet: $showingNewCarnivalSheet)
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




#Preview {
    ContentView()
        .environmentObject(CarnivalManager.shared)
}

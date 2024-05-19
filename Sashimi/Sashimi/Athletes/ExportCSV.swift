//
//  ExportCSV.swift
//  Sashimi
//
//  Created by Tom Keir on 19/5/2024.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct ExportCSV: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var carnivalManager = CarnivalManager.shared
    @State private var isExporting = false
    @State private var csvURL: URL?
    
    @State private var selectedCarnivals = Set<Carnival.ID>()

    var body: some View {
        VStack {
            Text("Export Athletes from the following carnivals:")
                .font(.headline)
            List(carnivalManager.carnivals) { carnival in
                HStack {
                    Toggle(isOn: Binding<Bool>(
                        get: { selectedCarnivals.contains(carnival.id) },
                        set: { isSelected in
                            if isSelected {
                                selectedCarnivals.insert(carnival.id)
                            } else {
                                selectedCarnivals.remove(carnival.id)
                            }
                        }
                    )) {
                        Text(carnival.name)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
            }
            .listStyle(.bordered)
            .alternatingRowBackgrounds()
            Text("This file can be imported into a new carnival.")
                .font(.subheadline)
            Button("Export Athletes (.csv)") { exportCSV(); dismiss() }
                .disabled(selectedCarnivals.isEmpty)
        }
        .frame(width: 380, height: 190)
        .padding()
        .fileExporter(
            isPresented: $isExporting,
            document: CSVFile(url: csvURL),
            contentType: .commaSeparatedText,
            defaultFilename: "athletes"
        ) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print("Failed to save: \(error.localizedDescription)")
            }
        }
    }
    
    func exportCSV() {
            let selectedCarnivalsList = carnivalManager.carnivals.filter { selectedCarnivals.contains($0.id) }
            let allAthletesCSV = selectedCarnivalsList.map { $0.generateAthletesCSV() }.joined(separator: "\n")
            if let url = saveCSV(text: allAthletesCSV) {
                csvURL = url
                isExporting = true
            }
        }

    func saveCSV(text: String) -> URL? {
        let fileName = "athletes.csv"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try text.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL
        } catch {
            print("Failed to create file: \(error.localizedDescription)")
            return nil
        }
    }
}

struct CSVFile: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    var url: URL?

    init(url: URL?) {
        self.url = url
    }

    init(configuration: ReadConfiguration) throws {
        fatalError("init(configuration:) has not been implemented")
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let url = url else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try FileWrapper(url: url)
    }
}

struct ExportCSVView_Previews: PreviewProvider {
    static var previews: some View {
        ExportCSV()
    }
}

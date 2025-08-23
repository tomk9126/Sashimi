//
//  AthletesList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 7/3/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation

struct AthletesList: View {
	// Showing various popups
    @State private var showingNewAthleteSheet = false
    @State private var showingEditAthleteSheet = false
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
	
    @State private var showingDeletionAlert = false
    
	@Binding var carnival: Carnival
    @State private var selection: Set<Athlete.ID> = []
    
	// If user selects 'reopen sheet after creation...' in NewAthlete
	@State var reopenSheet = false
    
	// Search function data
	@State private var searchText: String = ""
    @State var tokens: [Gender] = []
    
	// Import error alert
	@State private var importErrors: [String] = []
    @State private var showAlert = false

    func filteredAthletes(
        athletes: [Athlete],
        searchText: String
    ) -> [Athlete] {
        guard !searchText.isEmpty else { return athletes }
        return athletes.filter { athlete in
            let athleteGenderString = athlete.athleteGender == .male ? "Male" : "Female"
            return athlete.athleteFirstName.lowercased().contains(searchText.lowercased()) || athlete.athleteLastName.lowercased().contains(searchText.lowercased()) || athleteGenderString.lowercased() == searchText.lowercased()
        }
    }

    var body: some View {
        NavigationStack {
			Table(filteredAthletes(athletes: carnival.athletes, searchText: searchText), selection: $selection) {
                TableColumn("First Name", value: \.athleteFirstName)
                TableColumn("Last Name", value: \.athleteLastName)
                TableColumn("Gender") { athlete in
                    Text(athlete.athleteGender == .male ? "Male" : "Female")
                }
                TableColumn("DOB") { athlete in
                    Text(athlete.athleteDOB, format: .dateTime.day().month().year())
                }
            }
            .searchable(text: $searchText, prompt: "Find Athlete")
            .contextMenu(forSelectionType: Athlete.ID.self) { RightClickedEvent in
                Button {
                    selection = RightClickedEvent
                    print("Selection Changed:", RightClickedEvent)
                    showingEditAthleteSheet.toggle()
                } label: {
                    Label("Edit...", systemImage: "pencil")
                }
                Button("Delete", role: .destructive) {
                    showingDeletionAlert = true
                }
            } primaryAction: { items in
                showingEditAthleteSheet.toggle()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                Menu("Export Athletes", systemImage: "square.and.arrow.up") {
                    Button("Import Athletes (.csv)") {
                        selectAndImportCSV()
                    }
                    Button("Export Athletes (.csv)") {
                        showingExportSheet.toggle()
                    }
                }
                .help("Export all athletes. (.csv)")
                
                .frame(height: 28)
                Button("Edit Athlete", systemImage: "pencil") {
                    showingEditAthleteSheet.toggle()
                }
                .disabled(selection.isEmpty)
                .help("Edit athlete information.")
                Button("Delete Athlete", systemImage: "trash") {
                    showingDeletionAlert.toggle()
                }
                .disabled(selection.isEmpty)
                .help("Delete athlete.")
                
                Button("New Athlete", systemImage: "plus") {
                    showingNewAthleteSheet.toggle()
                }
                .help("Create new athlete")
            }
        }
        .sheet(isPresented: $showingNewAthleteSheet, onDismiss: checkReopenSheet) {
            NewAthlete(reopenAthleteSheet: $reopenSheet, carnival: carnival)
        }
        .sheet(isPresented: $showingEditAthleteSheet) {
            if let selectedAthlete = carnival.athletes.first(where: { selection.contains($0.id) }) {
				EditAthlete(carnival: carnival, athlete: selectedAthlete)
            } else {
                Text("No athlete selected")
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportCSV()
        }
        .alert("Delete Athlete?", isPresented: $showingDeletionAlert) {
            Button("Delete", role: .destructive) {
                if let athleteToDelete = selection.first {
                    carnival.athletes.removeAll(where: { $0.id == athleteToDelete })
                    selection = []
                }
            }
        } message: { Text("This action cannot be undone.") }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Import Errors"),
                message: Text(importErrors.joined(separator: "\n")),
                dismissButton: .default(Text("OK")) {
                    importErrors.removeAll()
                }
            )
        }
    }

    func checkReopenSheet() {
        if reopenSheet {
            showingNewAthleteSheet = true
        }
    }
    
    func importCSV(from file: URL) {
        let gotAccess = file.startAccessingSecurityScopedResource()
        defer {
            file.stopAccessingSecurityScopedResource()
        }
        guard gotAccess else {
            importErrors.append("Failed to access the file")
            return
        }
        
        do {
            let data = try Data(contentsOf: file)
            guard let content = String(data: data, encoding: .utf8) else {
                importErrors.append("Failed to decode the CSV file")
                return
            }
            let rows = content.components(separatedBy: .newlines)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.count == 4 {
                    let dob = dateFormatter.date(from: columns[2])
                    var gender: Gender
                    if columns[3].lowercased() == "male" {
                        gender = .male
                    } else if columns[3].lowercased() == "female" {
                        gender = .female
                    } else {
                        gender = .mixed
                    }
                    
                    if let dob = dob {
                        let newAthlete = Athlete(athleteFirstName: columns[0], athleteLastName: columns[1], athleteDOB: dob, athleteGender: gender)
                        carnival.athletes.append(newAthlete)
                    } else {
                        importErrors.append("Invalid date format for athlete: \(columns)")
                    }
                } else {
                    importErrors.append("Invalid data format for athlete: \(columns)")
                }
            }
            
            //Clear out false negative errors due to mismatches CSV formatting
            importErrors = importErrors.filter { $0 != #"Invalid data format for athlete: [""]"# }
            
            if !importErrors.isEmpty {
                importErrors.append("View 'Help' on data formatting.")
                showAlert = true
            }
        } catch {
            importErrors.append("Error reading file: \(error.localizedDescription)")
        }
    }
    
    func selectAndImportCSV() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.allowedContentTypes = [.commaSeparatedText]
        
        if openPanel.runModal() == .OK, let url = openPanel.url {
            importCSV(from: url)
        }
    }
}

#Preview {
    CarnivalManager.shared.exampleUsage()
    return ContentView()
        .environmentObject(CarnivalManager.shared)
        .frame(width: 850)
}

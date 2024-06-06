//
//  AthletesList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 7/3/2024.
//

import SwiftUI

struct AthletesList: View {
    
    
    @State private var showingNewAthleteSheet = false
    @State private var showingEditAthleteSheet = false
    @State private var showingExportSheet = false
    
    @State private var showingDeletionAlert = false
    
    @Binding var carnival: Carnival
    @Binding var athletes: [Athlete]
    @State private var selection: Set<Athlete.ID> = []
    
    @State var reopenSheet = false
    @State private var searchText: String = ""
    
    @State var tokens: [Gender] = []
    
    func filteredAthletes(
        athletes: [Athlete],
        searchText: String
    ) -> [Athlete] {
        // if there is no search query, just return all athletes
        guard !searchText.isEmpty else { return athletes }
        
        // filter athletes
        return athletes.filter { athlete in
            let athleteGenderString = athlete.athleteGender == .male ? "Male" : "Female"
            return athlete.athleteFirstName.lowercased().contains(searchText.lowercased()) || athlete.athleteLastName.lowercased().contains(searchText.lowercased()) || athleteGenderString.lowercased() == searchText.lowercased()
        }
    }
    
    var body: some View {
        NavigationStack {
            //MARK: Table
            Table(filteredAthletes(athletes: athletes, searchText: searchText), selection: $selection) {
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
        
        //MARK: Toolbar
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                
                Spacer()
                Button("Export Athletes", systemImage: "square.and.arrow.up") {
                    showingExportSheet.toggle()
                }
                .help("Export all athletes. (.csv)")
                
                HStack { // Embed in HStack as Divider() will otherwise present Horizontally.
                    Divider()
                }
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
                
                HStack { // Embed in HStack as Divider() will otherwise present Horizontally.
                    Divider()
                }
                .frame(height: 28)
                
                Button("New Athlete", systemImage: "plus") {
                    showingNewAthleteSheet.toggle()
                }
                .help("Create new athlete")
                
                
            }
        }
        //MARK: NewAthlete Sheet
        .sheet(isPresented: $showingNewAthleteSheet, onDismiss: checkReopenSheet) {
            NewAthlete(reopenAthleteSheet: $reopenSheet, carnival: carnival)
        }
        
        //MARK: EditAthlete Sheet
        .sheet(isPresented: $showingEditAthleteSheet) {
            
            if let selectedAthlete = carnival.athletes.first(where: { selection.contains($0.id) }) {
                EditAthlete(athlete: selectedAthlete, carnival: carnival)
            } else {
                // Handle case where no event is selected
                Text("No athlete selected")
            }
        }
        
        //MARK: Export Sheet
        .sheet(isPresented: $showingExportSheet) {
            ExportCSV()
        }
        
        //MARK: Deletion Alert
        .alert("Delete Athlete)?", isPresented: $showingDeletionAlert) {
            Button("Delete", role: .destructive) {
                if let athleteToDelete = selection.first {
                    carnival.athletes.removeAll(where: { $0.id == athleteToDelete })
                    selection = []
                }
            }
        } message: { Text("This action cannot be undone.")}
        
        
    }
    
    func checkReopenSheet() {
        if reopenSheet {
            showingNewAthleteSheet = true
        }
    }
}

#Preview {
    CarnivalManager.shared.exampleUsage()
    return ContentView()
        .environmentObject(CarnivalManager.shared)
}

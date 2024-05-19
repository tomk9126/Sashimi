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
    
    @ObservedObject var carnival: Carnival
    @Binding var athletes: [Athlete]
    @State private var selection: Set<Athlete.ID> = []
    
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
            VStack {
                Divider()
                HStack {
                    Text("\(carnival.athletes.count) Athletes")
                }
            }.background()
            
        }
        
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                HStack {
                    Button(action: { showingExportSheet.toggle()}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .help("Export all athletes. (.csv)")
                    
                    Divider()
                    
                    Button(action: { showingEditAthleteSheet.toggle()}) {
                        Image(systemName: "pencil")
                    }
                    .disabled(selection.isEmpty)
                    .help("Edit athlete information.")
                    
                    Button(action: {showingDeletionAlert.toggle()}) {
                        Image(systemName: "trash")
                    }
                    .disabled(selection.isEmpty)
                    .help("Delete athlete.")
                    
                    Divider()
                    
                    Button(action: { showingNewAthleteSheet.toggle()}) {
                        Image(systemName: "plus")
                    }
                    .help("Create new athlete")
                }
                
                
            }
        }
        .sheet(isPresented: $showingNewAthleteSheet) {
            NewAthlete(carnival: carnival)
        }
        .sheet(isPresented: $showingEditAthleteSheet) {
            
            if let selectedAthlete = carnival.athletes.first(where: { selection.contains($0.id) }) {
                EditAthlete(athlete: selectedAthlete, carnival: carnival)
            } else {
                // Handle case where no event is selected
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
        } message: { Text("This action cannot be undone.")}
        
        
    }
}

#Preview {
    VStack {
        
        @State var carnival = Carnival(name: "Test", date: Date.now)
        AthletesList(carnival: carnival, athletes: $carnival.athletes)
        Button("Generate Example Athlete") { CarnivalManager.shared.createAthlete(carnival: carnival, firstName: "First", lastName: "Last", DOB: Date.now, gender: .female) }
    }
    
}

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
    @State private var showingPopover = false
    @State private var showingDeletionAlert = false
    
    @ObservedObject var carnival: Carnival
    @Binding var athletes: [Athlete]
    @State private var selection: Set<Athlete.ID> = []
    
    var body: some View {
        NavigationStack {
            
            Table($athletes, selection: $selection) {
                TableColumn("First Name") { athlete in
                    TextField("", text: athlete.athleteFirstName)
                        .textFieldStyle(.squareBorder)
                }
                
                TableColumn("Last Name") { athlete in
                    TextField("", text: athlete.athleteLastName)
                        .textFieldStyle(.squareBorder)
                }
                TableColumn("Gender") { athlete in
                    Picker("", selection: athlete.athleteGender) {
                        Text("Male").tag(Gender.male)
                        Text("Female").tag(Gender.female)
                    }
                }
                TableColumn("DOB") { athleteBinding in
                    let athlete = athleteBinding.wrappedValue // Access the Athlete object from the binding

                    DatePicker("", selection: Binding<Date>(
                        get: {
                            athlete.athleteDOB
                        },
                        set: { newValue in
                            if let index = athletes.firstIndex(of: athlete) {
                                athletes[index].athleteDOB = newValue
                            }
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                }
            }
            .contextMenu(forSelectionType: Athlete.ID.self) { RightClickedEvent in
                Button {
                    selection = RightClickedEvent
                    print("Selection Changed:", RightClickedEvent)
                    showingPopover.toggle()
                } label: {
                    Label("Score...", systemImage: "list.clipboard")
                }
                Button {
                    selection = RightClickedEvent
                    print("Selection Changed:", RightClickedEvent)
                    showingPopover.toggle()
                } label: {
                    Label("Edit...", systemImage: "pencil")
                }
                Button("Delete", role: .destructive) {
                    showingDeletionAlert = true
                }
            } primaryAction: { items in
                showingPopover.toggle()
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
                    Button(action: { showingEditAthleteSheet.toggle()}) {
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

//
//  EventsList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct EventsList: View {
    
    @State private var showingNewEventSheet = false
    @State private var showingScoreEventSheet = false
    @State private var showingEditEventSheet = false
    @State private var showingRanksSheet = false
    
    @State private var showingDeletionAlert = false
    
    
    @State private var selection: Set<Event.ID> = []
    @State private var sortOrder = [KeyPathComparator(\Event.eventName)]
    
	// If user selects 'reopen sheet after event creation ...'
    @State var reopenSheet = false
    
    @Binding var carnival: Carnival
    
    var body: some View {
        NavigationStack {
            Table(carnival.events, selection: $selection, sortOrder: $sortOrder) {
                TableColumn("Event Name", value: \.eventName)
                TableColumn("Gender") { event in
                    switch event.eventGender {
                    case .male:
                        Text("Male")
                    case .female:
                        Text("Female")
                    case .mixed:
                        Text("Mixed")
                    }
                }
                TableColumn("Age Group") { event in
                    if let ageGroupText = (event.eventAgeGroup == nil ? "All Ages" : "Under \(String(describing: event.eventAgeGroup!))") {
                        Text(ageGroupText)
                    }
                }
                TableColumn("Scored?") { event in
                    //If Event contains Rank data, display Scored? = 'Yes'
                    Text(event.ranks != [:] ? "Yes" : "No")
                        .font(event.ranks != [:] ? .headline : .body)
                }
            }
            .onChange(of: sortOrder) { newOrder in
                carnival.events.sort(using: newOrder)
            }
            .contextMenu(forSelectionType: Event.ID.self) { RightClickedEvent in
                
                onAppear() {
                    selection = RightClickedEvent
                }
                Button {
                    print("Selection Changed:", RightClickedEvent)
                    showingRanksSheet.toggle()
                    
                } label: {
                    Label("View Ranks...", systemImage: "eye")
                }
                Button {
                    print("Selection Changed:", RightClickedEvent)
                    showingScoreEventSheet.toggle()
                    
                } label: {
                    Label("Score...", systemImage: "list.clipboard")
                }
                Button {
                    print("Selection Changed:", RightClickedEvent)
                    showingEditEventSheet.toggle()
                } label: {
                    Label("Edit...", systemImage: "pencil")
                }
                Button("Delete", role: .destructive) {
                    showingDeletionAlert = true
                }
            } primaryAction: { items in
                showingScoreEventSheet.toggle()
            }
            .toolbar {
                ToolbarItemGroup() {
                    Spacer()
                    HStack {
                        Button("View Ranks", systemImage: "eye") {
                            showingRanksSheet.toggle()
                        }
                        .disabled(selection.isEmpty)
                        .help("View previously generated ranks")
                        
                        Button("Score Event", systemImage: "list.bullet.clipboard") {
                            showingScoreEventSheet.toggle()
                        }
                        .disabled(selection.isEmpty)
                        .help("Score event.")
                        
                        Button("Edit Event", systemImage: "pencil") {
                            showingEditEventSheet.toggle()
                        }
                        .disabled(selection.isEmpty)
                        .help("Edit event information.")
                        
                        Button("Delete Event", systemImage: "trash") {
                            showingDeletionAlert.toggle()
                        }
                        .disabled(selection.isEmpty)
                        .help("Delete event.")
                        
                        HStack { // Embed in HStack as Divider() will otherwise present Horizontally.
                            Divider()
                        }
                        .frame(height: 28)
                        
                        Button("New Event", systemImage: "plus") {
                            showingNewEventSheet.toggle()
                        }
                        .help("Create new event(s).")
                    }
                    
                }

            }
        }
        //MARK: Delete Event Alert
        .alert("Delete Event?", isPresented: $showingDeletionAlert) {
            Button("Delete", role: .destructive) {
                if let eventToDelete = selection.first {
                    carnival.events.removeAll(where: { $0.id == eventToDelete })
                    selection = []
                }
            }
        } message: { Text("This action cannot be undone.")}
        
        
        //MARK: ScoreEvent Sheet
        .sheet(isPresented: $showingScoreEventSheet) {
            if let selectedEvent = $carnival.events.first(where: { selection.contains($0.id) }) {
                ScoreEvent(event: selectedEvent, carnival: $carnival)
                    .padding()
                    .frame(width: 800, height: 400)
                
            } else {
                Text("No event selected. This shouldn't happen.")
            }
        }
        
        //MARK: ShowingRanks Sheet
        .sheet(isPresented: $showingRanksSheet) {
            if let selectedEvent = carnival.events.first(where: { selection.contains($0.id) }) {
                Ranks(event: selectedEvent, carnival: carnival)
                
            } else {
                Text("No event selected. This shouldn't happen.")
            }
        }
        
        //MARK: EditEvent Sheet
        .sheet(isPresented: $showingEditEventSheet) {
            
            if let selectedEvent = carnival.events.first(where: { selection.contains($0.id) }) {
                EditEvent(event: selectedEvent)
            } else {
                // Handle case where no event is selected
                Text("No event selected")
            }
        }
        
        //MARK: NewEvent Sheet
        .sheet(isPresented: $showingNewEventSheet, onDismiss: checkReopenSheet) {
            NewEvent(reopenEventSheet: $reopenSheet, carnival: carnival)
        }
    }
    
    func checkReopenSheet() {
        if reopenSheet {
            showingNewEventSheet = true
        }
    }
}

#Preview {
    CarnivalManager.shared.exampleUsage()
    return ContentView()
        .environmentObject(CarnivalManager.shared)
}


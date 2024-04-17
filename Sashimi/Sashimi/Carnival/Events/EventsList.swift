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
    @State private var showingDeletionAlert = false
    
    @State private var selection: Set<Event.ID> = []
    @State private var sortOrder = [KeyPathComparator(\Event.eventName)]
    
    @ObservedObject var carnival: Carnival
    
    var body: some View {
        NavigationStack {
            Table(carnival.events, selection: $selection, sortOrder: $sortOrder) {
                //eventName: String. eventGender: String. eventGender: Int. "Scored?" Bool: If event.ranks contains data.
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
                    Text("Under \(event.eventAgeGroup)")
                }
                TableColumn("Scored?") { event in
                    //If Event contains Rank data, display Scored? = 'Yes'
                    Text(event.ranks != [:] ? "Yes" : "No")
                        .font(event.ranks != [:] ? .headline : .body)
                }
            }
            
            .onChange(of: selection) { newSelection in
                print("Selection Changed:", newSelection)
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
                    Button(action: {showingScoreEventSheet.toggle()}) {
                        Image(systemName: "list.bullet.clipboard")
                    }
                    .disabled(selection.isEmpty)
                    .help("Score event.")
                    Button(action: {showingEditEventSheet.toggle()}) {
                        Image(systemName: "pencil")
                    }
                    .disabled(selection.isEmpty)
                    .help("Edit event information.")
                    Button(action: {showingDeletionAlert.toggle()}) {
                        Image(systemName: "trash")
                    }
                    .disabled(selection.isEmpty)
                    .help("Delete event.")
                    Button(action: {showingNewEventSheet.toggle()}) {
                        Image(systemName: "plus")
                    }
                    .help("Create new event(s).")
                }

            }
        }
        .alert("Delete Event?", isPresented: $showingDeletionAlert) {
            Button("Delete", role: .destructive) {
                if let eventToDelete = selection.first {
                    carnival.events.removeAll(where: { $0.id == eventToDelete })
                    selection = []
                }
            }
        } message: { Text("This action cannot be undone.")}
        
        .sheet(isPresented: $showingScoreEventSheet) {
            
            if let selectedEvent = carnival.events.first(where: { selection.contains($0.id) }) {
                ScoreEvent(event: selectedEvent)
                    .padding()
            } else {
                Text("No event selected. This shouldn't happen.")
            }
        }
        .sheet(isPresented: $showingEditEventSheet) {
            
            if let selectedEvent = carnival.events.first(where: { selection.contains($0.id) }) {
                EditEvent(event: selectedEvent)
                    .padding()
            } else {
                // Handle case where no event is selected
                Text("No event selected")
            }
        }
        .sheet(isPresented: $showingNewEventSheet) {
            NewEvent(carnival: carnival)
                .padding()
        }
    }
}
#Preview {
    EventsList(carnival: Carnival(name: "Test", date: Date.now))
}


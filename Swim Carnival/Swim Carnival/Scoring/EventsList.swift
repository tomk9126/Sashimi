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
    @State private var events = Carnival().events
    
    var body: some View {
        NavigationStack {
            VStack {
                Table(events, selection: $selection, sortOrder: $sortOrder) {
                    TableColumn("Event Name", value: \.eventName)
                    TableColumn("Gender", value: \.eventGender)
                    TableColumn("Age Group", value: \.eventAgeGroup)
                }
                .onChange(of: selection) { newSelection in
                    print("Selection Changed:", newSelection)
                }
                .onChange(of: sortOrder) { newOrder in
                    events.sort(using: newOrder)
                }
                .contextMenu(forSelectionType: Event.ID.self) { RightClickedEvent in
                    Button {
                        selection = RightClickedEvent
                        print("Selection Changed:", RightClickedEvent)
                        showingScoreEventSheet.toggle()
                    } label: {
                        Label("Score...", systemImage: "list.clipboard")
                    }
                    Button {
                        selection = RightClickedEvent
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
                        Button(action: {
                            showingNewEventSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .alert(
                "Delete Event?",
                isPresented: $showingDeletionAlert
            ) {
                Button("Delete", role: .destructive) {
                    // Handle the acknowledgement.
                }
            } message: {
                Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showingScoreEventSheet) {
            
            if let selectedEvent = events.first(where: { selection.contains($0.id) }) {
                ScoreEvent(event: selectedEvent)
                    .padding(.leading)
            } else {
                // Handle case where no event is selected
                Text("No event selected")
            }
        }
        .sheet(isPresented: $showingEditEventSheet) {
            
            if let selectedEvent = events.first(where: { selection.contains($0.id) }) {
                EditEvent(event: selectedEvent)
                    .padding(.leading)
            } else {
                // Handle case where no event is selected
                Text("No event selected")
            }
        }
        .sheet(isPresented: $showingNewEventSheet) {
            NewEvent()
                .padding()
        }
    }
}

#Preview {
    EventsList()
}

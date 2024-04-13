//
//  EventsList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

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
            VStack {
                Table(carnival.events, selection: $selection, sortOrder: $sortOrder) {
                    TableColumn("Event Name", value: \.eventName)
                    TableColumn("Gender", value: \.eventGender)
                    TableColumn("Age Group", value: \.eventAgeGroup)
                }
                .id(UUID())
                
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
                    if let eventToDelete = selection.first {
                        carnival.events.removeAll(where: { $0.id == eventToDelete })
                        selection = []
                    }
                }
            } message: {
                Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showingScoreEventSheet) {
            
            if let selectedEvent = carnival.events.first(where: { selection.contains($0.id) }) {
                ScoreEvent(event: selectedEvent)
                    .padding(.leading)
            } else {
                Text("No event selected. This shouldn't happen.")
            }
        }
        .sheet(isPresented: $showingEditEventSheet) {
            
            if let selectedEvent = carnival.events.first(where: { selection.contains($0.id) }) {
                EditEvent(event: selectedEvent)
                    .padding(.leading)
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


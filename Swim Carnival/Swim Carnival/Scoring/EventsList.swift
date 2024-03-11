//
//  EventsList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct EventsList: View {
    struct Event: Identifiable {
        let eventName: String
        let eventGender: String
        let eventAgeGroup: String
        let id = UUID()

    }
    
    @State private var events = [
        Event(eventName: "Freestyle", eventGender: "Boys", eventAgeGroup: "Under 15"),
    ]
    
    @State private var showingNewEventSheet = false
    @State private var showingScoreEventSheet = false
    
    @State private var selection: Set<Event.ID> = []
    var body: some View {
        NavigationStack {
            Table(events, selection: $selection) {
                        TableColumn("Event Name", value: \.eventName)
                        TableColumn("Gender", value: \.eventGender)
                        TableColumn("Age Group", value: \.eventAgeGroup)
                    }
                    .contextMenu(forSelectionType: Event.ID.self) { items in
                            Button {
                                showingScoreEventSheet.toggle()
                            } label: {
                                Label("Score...", systemImage: "list.clipboard")
                            }
                            Button {
                                // Edit Event Data
                            } label: {
                                Label("Edit...", systemImage: "pencil")
                            }
                            Button("Delete", role: .destructive) {
                                // Delete Event
                            }
                    } primaryAction: { items in
                        showingScoreEventSheet.toggle()
                        
                    }

                    
        }
        .navigationTitle(Text("Carnival Name"))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                Button("Show Sheet", systemImage: "plus") {
                            showingNewEventSheet.toggle()
                        }
                        .labelStyle(.iconOnly)
  
            }
        }
        .sheet(isPresented: $showingScoreEventSheet) {
            ScoreEvent()
                .padding(.leading)
        }
        .sheet(isPresented: $showingNewEventSheet) {
            NewEvent()
                .padding(.leading)
        }
        
        
    }
}

#Preview {
    EventsList()
}

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
    
    @State private var selection: Set<Event.ID> = []
    @State private var sortOrder = [KeyPathComparator(\Event.eventName)]
    @State var events = Carnival().events
    var body: some View {
        NavigationStack {
            Table(events, selection: $selection, sortOrder: $sortOrder) {
                        TableColumn("DEBUG ID", value: \.idString)
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
                    .onChange(of: sortOrder) { newOrder in
                        events.sort(using: newOrder)
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

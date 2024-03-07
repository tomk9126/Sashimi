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
    
    @State private var showingSheet = false
    
    @State private var selection: Set<Event.ID> = []
    var body: some View {
        NavigationStack {
            Table(events, selection: $selection) {
                        TableColumn("Event Name", value: \.eventName)
                        TableColumn("Gender", value: \.eventGender)
                        TableColumn("Age Group", value: \.eventAgeGroup)
                    }
                    .contextMenu {
                            Button {
                                // Score Event
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
                        }
        }
        .navigationTitle(Text("Carnival Name"))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                Button("Show Sheet", systemImage: "plus") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            NewEvent()
                                .padding(.leading)
                        }
                        .labelStyle(.iconOnly)
                
                
                    
                
            }
        }
        
        
    }
}

#Preview {
    EventsList()
}

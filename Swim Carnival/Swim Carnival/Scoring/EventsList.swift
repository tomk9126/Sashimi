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
    
    @State private var selection: Set<Event.ID> = []
    var body: some View {
        Table(events, selection: $selection) {
                    TableColumn("Event Name", value: \.eventName)
                    TableColumn("Gender", value: \.eventGender)
                    TableColumn("Age Group", value: \.eventAgeGroup)
                }
        
    }
}

#Preview {
    EventsList()
}

//
//  EditEvent.swift
//  Swim Carnival
//
//  Created by Tom Keir on 13/3/2024.
//

import SwiftUI

struct EditEvent: View {
    @Environment(\.dismiss) var dismiss
    var event: Event

    var body: some View {
        VStack {
            Text("Scoring \(event.eventName)")
            Text("Gender: \(event.eventGender)")
            Text("Age Group: \(event.eventAgeGroup)")
        }
        .padding()
        Button("Cancel", role: .cancel) {
            dismiss()
        }.keyboardShortcut(.cancelAction)
    }
}

#Preview {
    EditEvent(event: Event(eventName: "Event Name", eventGender: "Gender", eventAgeGroup: "Age"))
}

//
//  ScoreEvent.swift
//  Swim Carnival
//
//  Created by Tom Keir on 11/3/2024.
//

import SwiftUI

struct ScoreEvent: View {
    @Environment(\.dismiss) var dismiss
    @State var event: Event

    var body: some View {
        VStack {
            Text("Scoring \(event.eventName)")
            Text("Gender: \(event.eventGender)")
            Text("Age Group: \(event.eventAgeGroup)")
            Button("Cancel", role: .cancel) {
                dismiss()
            }.keyboardShortcut(.cancelAction)
        }
        .padding()
        
    }
}

#Preview {
    ScoreEvent(event: Event(eventName: "Event Name", eventGender: "Gender", eventAgeGroup: "Age"))
}

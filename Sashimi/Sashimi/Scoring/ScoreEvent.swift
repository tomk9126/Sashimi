//
//  ScoreEvent.swift
//  Sashimi
//
//  Created by Tom Keir on 25/4/2024.
//

import SwiftUI

struct ScoreEvent: View {
    let event: Event
    @State var carnival: Carnival
    @State private var selectedAthletes: [Athlete] = []
    @State var showingView = 0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack (spacing: 2) {
                Text("\(event.eventName), ")
                Text("\(event.eventGender == .mixed ? "Mixed, " : event.eventGender == .male ? "Male, " : "Female, ")")
                if let eventAgeGroup = event.eventAgeGroup {
                    Text("\(eventAgeGroup), ")
                } else {
                    Text("All Ages")
                }
            }

            Divider()
            if showingView == 0 {
                AthleteSelection(event: event, carnival: carnival, selectedAthletes: $selectedAthletes)
            } else if showingView == 1 {
                AthleteScoring(selectedAthletes: $selectedAthletes)
            }
            
            Divider()
            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                    
                Button(showingView == 0 ? "Next" : "Finalise") {
                    if showingView == 0 { showingView = 1 } else { dismiss() }
                }.keyboardShortcut(.defaultAction)
                    .disabled(selectedAthletes.count == 0)
            }
        }
    }
}

#Preview {
    ScoreEvent(event: Event(eventName: "100m Freestyle", eventGender: .female), carnival: Carnival(name: "", date: Date.now))
        .padding()
}

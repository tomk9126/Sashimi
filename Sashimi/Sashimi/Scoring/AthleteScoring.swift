//
//  AthleteScoring.swift
//  Sashimi
//
//  Created by Tom Keir on 25/4/2024.
//

import SwiftUI

struct AthleteScoring: View {
    @Binding var selectedAthletes: [Athlete]
    
    var body: some View {
        Text("hello")
    }
}

#Preview {
    ScoreEvent(event: Event(eventName: "Event Name", eventGender: .mixed, eventAgeGroup: 21), carnival: Carnival(name: "", date: Date.now))
        .padding()
}

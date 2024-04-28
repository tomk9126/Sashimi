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
    
    @State private var eventScores: [Athlete: Time] = [:]
    @State private var isShowingRankAlert = false
    @State private var rankAlertMessage = ""
    
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
                AthleteScoring(selectedAthletes: $selectedAthletes, eventScores: $eventScores)
                    .onAppear {
                        // Initialize eventScores with entries for each athlete
                        eventScores = Dictionary(uniqueKeysWithValues: selectedAthletes.map { ($0, Time(minutes: 0, seconds: 0, milliseconds: 0)) })
                    }
                    .onDisappear {
                        calculateRanks()
                    }
            }
            
            Divider()
            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                    
                Button(showingView == 0 ? "Next" : "Finalise") {
                    if showingView == 0 {
                        showingView = 1
                    } else {
                        calculateRanks()
                        isShowingRankAlert = true
                    }
                }.keyboardShortcut(.defaultAction)
                .disabled(selectedAthletes.count == 0)
            }
        }
        .alert(isPresented: $isShowingRankAlert) {
            Alert(title: Text("Athlete Ranks"), message: Text(rankAlertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func calculateRanks() {
        // Calculate total milliseconds for each athlete
        var athleteTotalMilliseconds: [Athlete: Int] = [:]
        for (athlete, time) in eventScores {
            let totalMilliseconds = time.minutes * 60 * 1000 + time.seconds * 1000 + time.milliseconds
            athleteTotalMilliseconds[athlete] = totalMilliseconds
        }
        
        // Sort athletes based on total milliseconds
        let sortedAthletes = athleteTotalMilliseconds.sorted { $0.value < $1.value }
        
        // Generate rank message
        var rankMessage = ""
        for (index, (athlete, _)) in sortedAthletes.enumerated() {
            rankMessage += "\(index + 1). \(athlete.athleteFirstName) \(athlete.athleteLastName)\n"
        }
        
        rankAlertMessage = rankMessage
    }
}

#Preview {
    ScoreEvent(event: Event(eventName: "100m Freestyle", eventGender: .female), carnival: Carnival(name: "", date: Date.now))
        .padding()
}

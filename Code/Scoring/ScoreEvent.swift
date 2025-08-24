//
//  ScoreEvent.swift
//  Sashimi
//
//  Created by Tom Keir on 25/4/2024.
//

import SwiftUI

struct ScoreEvent: View {
    @Binding var event: Event
    @Binding var carnival: Carnival
    
    @State private var selectedAthletes: [Athlete] = []
    
    @State var showingView = 0
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowingRankAlert = false
    @State private var rankAlertMessage = ""
    
    var body: some View {
        VStack {
            HStack (spacing: 2) {
                Text("\(event.eventName), ")
                Text("\(event.eventSex == .mixed ? "Mixed, " : event.eventSex == .male ? "Male, " : "Female, ")")
                if let eventAgeGroup = event.eventAgeGroup {
                    Text("\(eventAgeGroup), ")
                } else {
                    Text("All Ages")
                }
            }
            Text("If previous rank data exists, it will be overwitten")
                .font(.subheadline)
            
            if showingView == 0 {
                AthleteSelection(event: event, carnival: carnival, selectedAthletes: $selectedAthletes)
                    .tag(0)
                    .tabItem() {
                        Label("Athlete Selection", systemImage: "person.fill")
                    }
                    .padding()
                
            } else {
                AthleteScoring(eventScores: $event.results, athletes: selectedAthletes)
                    .tag(1)
                    .tabItem() {
                        Label("Times", systemImage: "person.fill")
                    }
                    .padding()
            }
            

            HStack {
                Button(showingView == 0 ? "Cancel" : "Back") {
                    if showingView == 0 {
                        dismiss()
                    } else {
                        showingView = 0
                    }
                }.keyboardShortcut(.cancelAction)
                    
                Button(showingView == 0 ? "Next" : "Finalise") {
                    if showingView == 0 {
                        showingView = 1
                        
                        //New athletes selected (if event previously ranked), so clear previous results
                        event.ranks = [:]
                        event.results = [:]
                    } else {
                        //event.results = [:]
                        event.calculateEventRanks()
                        print(event)
                        dismiss()
                        
                    }
                }.keyboardShortcut(.defaultAction)
                .disabled(selectedAthletes.count == 0)
            }
        }
        
    }
    
    
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            @State var carnival = Carnival(name: "Carnival", date: Date.now)
            @State var event = Event(eventName: "100m Freestyle", eventSex: .male, eventAgeGroup: 14)
            ScoreEvent(event: $event , carnival: $carnival)
                .padding()
        }
    }
    return PreviewWrapper()
    
}

//
//  AthleteScoring.swift
//  Sashimi
//
//  Created by Tom Keir on 25/4/2024.
//

import SwiftUI

struct AthleteScoring: View {
    @Binding var eventScores: [Athlete: Time]
    @State var athletes: [Athlete]
    
    var body: some View {
        VStack {
            Text("Race Times")
                .font(.headline)
            Table(athletes) {
                TableColumn("Athlete") { athlete in
                    Text(athlete.athleteFirstName + " " + athlete.athleteLastName)
                }
                TableColumn("Time") { athlete in
                    TimePickerView(eventScores: $eventScores, athlete: athlete)
                }
            }.tableStyle(.bordered)
            
            Text("Enter athlete times for event, then click 'Finalise'")
                .padding(.vertical, 3.0)
        }
    }
    
}

struct TimePickerView: View {
    @Binding var eventScores: [Athlete: Time]
    let athlete: Athlete
    
    @State private var minutes: Int
    @State private var seconds: Int
    @State private var milliseconds: Int
    
    init(eventScores: Binding<[Athlete: Time]>, athlete: Athlete) {
        self._eventScores = eventScores
        self.athlete = athlete
        
        let time = eventScores.wrappedValue[athlete] ?? Time(minutes: 0, seconds: 0, milliseconds: 0)
        self._minutes = State(initialValue: time.minutes)
        self._seconds = State(initialValue: time.seconds)
        self._milliseconds = State(initialValue: time.milliseconds)
    }
    
    var body: some View {
        HStack {
            TextField("MM", value: $minutes, formatter: NumberFormatter())
                .textFieldStyle(.plain)
                .frame(width: 18)
            
            Text(":")
            
            TextField("SS", value: $seconds, formatter: NumberFormatter())
                .textFieldStyle(.plain)
                .frame(width: 18)
            
            Text(".")
            
            TextField("ss", value: $milliseconds, formatter: NumberFormatter())
                .textFieldStyle(.plain)
                .frame(width: 18)
        }
        //.frame(width: 200)
        .padding(4.0)
        .onChange(of: minutes) { newValue in
            updateEventScores()
        }
        .onChange(of: seconds) { newValue in
            updateEventScores()
        }
        .onChange(of: milliseconds) { newValue in
            updateEventScores()
        }
    }
    
    private func updateEventScores() {
        var time = Time(minutes: minutes, seconds: seconds, milliseconds: milliseconds)
        eventScores[athlete] = time
    }
}

#Preview {
    @State var event = Event(eventName: "100m Freestyle", eventGender: .mixed)
    @State var athlete1 = Athlete(athleteFirstName: "Mark", athleteLastName: "Smith", athleteDOB: Date.now, athleteGender: .male)
    @State var athlete2 = Athlete(athleteFirstName: "Sarah", athleteLastName: "Jones", athleteDOB: Date.now, athleteGender: .female)
    @State var athletes = [athlete1, athlete2]
    return AthleteScoring(eventScores: $event.results, athletes: athletes)
        .padding()
}

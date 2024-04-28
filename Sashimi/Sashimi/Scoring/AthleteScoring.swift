//
//  AthleteScoring.swift
//  Sashimi
//
//  Created by Tom Keir on 25/4/2024.
//

import SwiftUI

struct AthleteScoring: View {
    @Binding var selectedAthletes: [Athlete]
    @Binding var eventScores: [Athlete: Time]
    
    var body: some View {
        Table(selectedAthletes) {
            TableColumn("Athlete Name") { athlete in
                Text(athlete.athleteFirstName + " " + athlete.athleteLastName)
            }
            
            TableColumn("MM:SS.ss") { athlete in
                TimePickerView(eventScores: $eventScores, athlete: athlete)
            }
            
            TableColumn("Total Milliseconds") { athlete in
                Text("\(totalMilliseconds(for: athlete))")
            }
        }
        .tableStyle(.bordered)
        .onAppear {
            // Initialize eventScores with entries for each athlete
            for athlete in selectedAthletes {
                if eventScores[athlete] == nil {
                    eventScores[athlete] = Time(minutes: 0, seconds: 0, milliseconds: 0)
                }
            }
        }
    }
    
    private func totalMilliseconds(for athlete: Athlete) -> Int {
        guard let time = eventScores[athlete] else {
            return 0
        }
        return time.minutes * 60 * 1000 + time.seconds * 1000 + time.milliseconds
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
            TextField("Minute", value: $minutes, formatter: NumberFormatter())
                .textFieldStyle(.plain)
            
            Text(":")
            
            TextField("Second", value: $seconds, formatter: NumberFormatter())
                .textFieldStyle(.plain)
            
            Text(".")
            
            TextField("Millisecond", value: $milliseconds, formatter: NumberFormatter())
                .textFieldStyle(.plain)
        }
        .frame(width: 200)
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
    let athlete1 = Athlete(athleteFirstName: "John", athleteLastName: "Smith", athleteDOB: Date.now, athleteGender: .male)
    let athlete2 = Athlete(athleteFirstName: "Tom", athleteLastName: "Keir", athleteDOB: Date.now, athleteGender: .male)
    @State var selectedAthletes: [Athlete] = [athlete1, athlete2]
    @State var eventScores: [Athlete : Time] = [athlete1 : Time(minutes: 0, seconds: 0, milliseconds: 0), athlete2: Time(minutes: 0, seconds: 0, milliseconds: 0)]
    return AthleteScoring(selectedAthletes: $selectedAthletes, eventScores: $eventScores)
        .padding()
        .frame(width: 300)
}

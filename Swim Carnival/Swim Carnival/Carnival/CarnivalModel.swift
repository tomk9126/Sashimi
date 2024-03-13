//
//  CarnivalStruct.swift
//  Swim Carnival
//
//  Created by Tom Keir on 11/3/2024.
//

import Foundation

struct Athlete: Identifiable {
    let athleteFirstName: String
    let athleteLastName: String
    let athleteDOB: String
    let id = UUID()

}

struct Event: Hashable, Identifiable {
    let eventName: String
    let eventGender: String
    let eventAgeGroup: String
    let id = UUID()

}

struct Carnival {
    var athletes = [
        Athlete(athleteFirstName: "John", athleteLastName: "Smith", athleteDOB: " "),
    ]
    var events = [
        Event(eventName: "100m Freestyle", eventGender: "Boys", eventAgeGroup: "Under 15"),
        Event(eventName: "50m Freestyle", eventGender: "Girls", eventAgeGroup: "Under 13"),
        Event(eventName: "100 Freestyle", eventGender: "Boys", eventAgeGroup: "Under 17"),
    ]
}





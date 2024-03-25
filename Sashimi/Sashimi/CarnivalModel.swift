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

class Carnival: Identifiable, Hashable {
    
    static func == (lhs: Carnival, rhs: Carnival) -> Bool {
            return lhs.id == rhs.id
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var name: String
    var date: Date
    var athletes: [Athlete]
    var events: [Event]
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
        self.athletes = []
        self.events = []
    }
    
    func addAthlete(_ athlete: Athlete) {
        athletes.append(athlete)
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
    }
    
    func removeAthlete(_ athlete: Athlete) {
        athletes.removeAll { $0.id == athlete.id }
    }
    
    func removeEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
    }
    
    func getAthleteById(_ athleteId: UUID) -> Athlete? {
        return athletes.first { $0.id == athleteId }
    }
    
    func getEventById(_ eventId: UUID) -> Event? {
        return events.first { $0.id == eventId }
    }
}

class CarnivalManager: ObservableObject {
    
    static let shared = CarnivalManager()
    
    @Published var carnivals: [Carnival]
    @Published var carnivalNames: [String]
    
    private init() {
        self.carnivals = []
        self.carnivalNames = []
    }
    
    func createCarnival(name: String, date: Date) -> Carnival {
        let newCarnival = Carnival(name: name, date: date)
        carnivals.append(newCarnival)
        carnivalNames.append(name)
        return newCarnival
    }
    
    func deleteCarnival(_ carnival: Carnival) {
        if let index = carnivals.firstIndex(where: { $0.name == carnival.name }) {
            carnivals.remove(at: index)
            carnivalNames.remove(at: index)
        }
    }
    
    func createEvent(carnival: Carnival, name: String, gender: String, age: String) -> Event {
        let newEvent = Event(eventName: name, eventGender: gender, eventAgeGroup: age)
        carnival.events.append(newEvent)
        return newEvent
    }
    
    func getCarnivalByName(_ name: String) -> Carnival? {
        return carnivals.first { $0.name == name }
    }
    
    func exampleUsage() {
        // Create a new carnival
        let carnival1 = CarnivalManager.shared.createCarnival(name: "Summer Carnival", date: Date.now)

        // Add athletes to carnival1
        let athlete1 = Athlete(athleteFirstName: "John", athleteLastName: "Smith", athleteDOB: "1998-01-15")
        let athlete2 = Athlete(athleteFirstName: "Alice", athleteLastName: "Johnson", athleteDOB: "2000-07-22")
        carnival1.addAthlete(athlete1)
        carnival1.addAthlete(athlete2)

        // Add events to carnival1
        let event1 = Event(eventName: "100m Freestyle", eventGender: "Boys", eventAgeGroup: "Under 15")
        let event2 = Event(eventName: "200m Butterfly", eventGender: "Girls", eventAgeGroup: "Under 16")
        carnival1.addEvent(event1)
        carnival1.addEvent(event2)

        // Create another carnival
        let carnival2 = CarnivalManager.shared.createCarnival(name: "Winter Carnival", date: Date.now)

        // Add athletes to carnival2
        let athlete3 = Athlete(athleteFirstName: "Michael", athleteLastName: "Chang", athleteDOB: "1999-05-10")
        let athlete4 = Athlete(athleteFirstName: "Emily", athleteLastName: "Davis", athleteDOB: "2002-11-30")
        carnival2.addAthlete(athlete3)
        carnival2.addAthlete(athlete4)

        // Add events to carnival2
        let event3 = Event(eventName: "50m Freestyle", eventGender: "Girls", eventAgeGroup: "Under 13")
        let event4 = Event(eventName: "200m Individual Medley", eventGender: "Boys", eventAgeGroup: "Under 17")
        carnival2.addEvent(event3)
        carnival2.addEvent(event4)

        // Retrieve a carnival by name
        if let winterCarnival = CarnivalManager.shared.getCarnivalByName("Winter Carnival") {
            print("Winter Carnival Events:")
            for event in winterCarnival.events {
                print("\(event.eventName) - \(event.eventGender) - \(event.eventAgeGroup)")
            }
        }

        // Delete a carnival
        if let summerCarnival = CarnivalManager.shared.getCarnivalByName("Summer Carnival") {
            CarnivalManager.shared.deleteCarnival(summerCarnival)
        }

        // Print all carnivals and their events
        for carnival in CarnivalManager.shared.carnivals {
            print("\n\(carnival.name) Events:")
            for event in carnival.events {
                print("\(event.eventName) - \(event.eventGender) - \(event.eventAgeGroup)")
            }
        }
    }
    

}


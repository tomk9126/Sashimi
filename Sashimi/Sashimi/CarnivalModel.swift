//
//  CarnivalStruct.swift
//  Swim Carnival
//
//  Created by Tom Keir on 11/3/2024.
//

import Foundation
import SwiftUI

//Data type Gender
enum Gender {
    case male
    case female
    case mixed
}

//Data type Athlete
struct Athlete: Hashable, Identifiable {
    var athleteFirstName: String
    var athleteLastName: String
    var athleteDOB: String
    var id = UUID()
}

//Data type Event
struct Event: Hashable, Identifiable {
    var eventName: String
    var eventGender: Gender
    var eventAgeGroup: Int? //Optional value because an event may be mixed-ages. If there is no value, this is the case.
    var ranks: [String: Int] = [:] //Scoring data
    var id = UUID()
}

class Carnival: ObservableObject, Identifiable, Hashable {
    
    //The following Allows Carnival to conform to equatable.
    //This means operators such as '==' and '!=' can be used on this datatype.
    static func == (lhs: Carnival, rhs: Carnival) -> Bool {
            return lhs.id == rhs.id
    }

    
    
    //The following Allows Carnival, Events, and Athletes to conform to Hashable.
    //This gives every Carnival, Event, and Athlete a unique ID.
    /* Why use IDs?
        This allows for multiple data entries to contain the exact same data. For example, duplicate data (Or maybe a very unlucky instance where two Athletes have the same name and DOB!)
     */
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var name: String
    var date: Date
    @Published var athletes: [Athlete]
    @Published var events: [Event]
    
    //Initiate 'Carnival'
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
    
    /* An explanation on removal functions
     Since all Events, Athletes, and Carnivals are identified by UUIDs, we need to retrive the datatypes from their IDs before they can be manipulated.
     The removal functions below works as follows:
        'Remove every entry that has the same ID as our current selection, where $0 is our selection'
     
     */
    func removeAthlete(_ athlete: Athlete) {
        athletes.removeAll { $0.id == athlete.id }
    }
    
    func removeEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
    }
}

class CarnivalManager: ObservableObject {
    
    //allows data manipulation from any area of the app by using CarnivalManager.shared. ...
    static let shared = CarnivalManager()
    
    @Published var carnivals: [Carnival]
    
    private init() {
        self.carnivals = []
    }
    
    func createCarnival(name: String, date: Date) -> Carnival {
        let newCarnival = Carnival(name: name, date: date)
        carnivals.append(newCarnival)
        return newCarnival
    }
    
    func deleteCarnival(_ carnival: Carnival) {
        if let index = carnivals.firstIndex(where: { $0.name == carnival.name }) {
            carnivals.remove(at: index)
        }
    }
    
    func createEvent(carnival: Carnival, name: String, gender: Gender, age: Int) -> Event {
        let newEvent = Event(eventName: name, eventGender: gender, eventAgeGroup: age)
        carnival.events.append(newEvent)
        return newEvent
    }
    
    func updateEvent(event: Event, newName: String, newGender: Gender, newAge: Int?) {
            if let index = eventIndexInCarnivals(event: event) {
                carnivals[index].events.removeAll { $0.id == event.id }
                let updatedEvent = Event(eventName: newName, eventGender: newGender, eventAgeGroup: newAge)
                carnivals[index].events.append(updatedEvent)
            }
        }
        
        private func eventIndexInCarnivals(event: Event) -> Int? {
            for (index, carnival) in carnivals.enumerated() {
                if let _ = carnival.events.firstIndex(where: { $0.id == event.id }) {
                    return index
                }
            }
            return nil
        }
    
    func createAthlete(carnival: Carnival, firstName: String, lastName: String, DOB: String) -> Athlete {
        let newAthlete = Athlete(athleteFirstName: firstName, athleteLastName: lastName, athleteDOB: DOB)
        carnival.athletes.append(newAthlete)
        return newAthlete
    }
    
    func exampleUsage() { //Provides some sample data for quick testing and debug
        let carnival1 = CarnivalManager.shared.createCarnival(name: "KHC Swimming Carnival", date: Date.now)

        let exampleEvents = [
            Event(eventName: "50m Freestyle", eventGender: .female, eventAgeGroup: 13),
        ]
        for event in exampleEvents {
            carnival1.addEvent(event)
        }
        
        let exampleAthletes = [
            Athlete(athleteFirstName: "Michael", athleteLastName: "Chang", athleteDOB: "1999-05-10"),
            Athlete(athleteFirstName: "Emily", athleteLastName: "Davis", athleteDOB: "2002-11-30")
        ]
        
        for athlete in exampleAthletes {
            carnival1.addAthlete(athlete)
        }
        
    }
    

}


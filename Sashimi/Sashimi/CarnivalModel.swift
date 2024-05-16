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
    var athleteDOB: Date
    var athleteGender: Gender
    var id = UUID()
}

//Data type Event
struct Event: Hashable, Identifiable {
    var eventName: String
    var eventGender: Gender
    var eventAgeGroup: Int? //Optional value because an event may be mixed-ages. If there is no value, this is the case.
    var scores: [Athlete: Time]?
    var ranks: [String: Int] = [:] //Scoring data
    var id = UUID()
}

struct Time: Hashable {
    var minutes: Int
    var seconds: Int
    var milliseconds: Int
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
    
    func createAthlete(carnival: Carnival, firstName: String, lastName: String, DOB: Date, gender: Gender) -> Athlete {
        let newAthlete = Athlete(athleteFirstName: firstName, athleteLastName: lastName, athleteDOB: DOB, athleteGender: gender)
        carnival.athletes.append(newAthlete)
        return newAthlete
    }
    
    func updateAthlete(athlete: Athlete, newFirstName: String, newLastName: String, newGender: Gender, newDOB: Date) {
        if let index = athleteIndexInCarnivals(athlete: athlete) {
            carnivals[index].athletes.removeAll { $0.id == athlete.id }
            let updatedAthlete = Athlete(athleteFirstName: newFirstName, athleteLastName: newLastName, athleteDOB: newDOB, athleteGender: newGender)
            carnivals[index].athletes.append(updatedAthlete)
        }
    }
    
    private func athleteIndexInCarnivals(athlete: Athlete) -> Int? {
        for (index, carnival) in carnivals.enumerated() {
            if let _ = carnival.athletes.firstIndex(where: { $0.id == athlete.id }) {
                return index
            }
        }
        return nil
    }
    
    func exampleUsage() {
        let carnival1 = CarnivalManager.shared.createCarnival(name: "KHC Swimming Carnival", date: Date())

        let exampleEvents1 = [
            Event(eventName: "50m Freestyle", eventGender: .male),
            Event(eventName: "50m Freestyle", eventGender: .female),
            Event(eventName: "50m Freestyle", eventGender: .mixed),
            Event(eventName: "100m Freestyle", eventGender: .male, eventAgeGroup: 13),
            Event(eventName: "100m Freestyle", eventGender: .female, eventAgeGroup: 13),
            Event(eventName: "100m Freestyle", eventGender: .mixed, eventAgeGroup: 13),
        ]
        for event in exampleEvents1 {
            carnival1.addEvent(event)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let exampleAthletes1 = [
            Athlete(athleteFirstName: "Michael", athleteLastName: "Chang", athleteDOB: dateFormatter.date(from: "1999-05-10") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Emily", athleteLastName: "Davis", athleteDOB: dateFormatter.date(from: "2002-11-30") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "John", athleteLastName: "Smith", athleteDOB: dateFormatter.date(from: "2004-08-20") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Emma", athleteLastName: "Wilson", athleteDOB: dateFormatter.date(from: "2003-03-12") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "James", athleteLastName: "Johnson", athleteDOB: dateFormatter.date(from: "2000-09-05") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Sophie", athleteLastName: "Brown", athleteDOB: dateFormatter.date(from: "2002-12-15") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "Matthew", athleteLastName: "Garcia", athleteDOB: dateFormatter.date(from: "2005-02-28") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Isabella", athleteLastName: "Martinez", athleteDOB: dateFormatter.date(from: "2003-06-10") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "Alexander", athleteLastName: "Lee", athleteDOB: dateFormatter.date(from: "2001-04-17") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Ava", athleteLastName: "Lopez", athleteDOB: dateFormatter.date(from: "2004-10-22") ?? Date(), athleteGender: .female)
        ]

        for athlete in exampleAthletes1 {
            carnival1.addAthlete(athlete)
        }

        let carnival2 = CarnivalManager.shared.createCarnival(name: "BHC Swimming Carnival", date: Date())

        let exampleEvents2 = [
            Event(eventName: "200m Medley", eventGender: .male),
            Event(eventName: "200m Medley", eventGender: .female),
            Event(eventName: "200m Medley", eventGender: .mixed),
            Event(eventName: "50m Butterfly", eventGender: .male),
            Event(eventName: "50m Butterfly", eventGender: .female),
            Event(eventName: "50m Butterfly", eventGender: .mixed),
        ]
        for event in exampleEvents2 {
            carnival2.addEvent(event)
        }

        let exampleAthletes2 = [
            Athlete(athleteFirstName: "Ryan", athleteLastName: "Smith", athleteDOB: dateFormatter.date(from: "2001-08-15") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Sophia", athleteLastName: "Johnson", athleteDOB: dateFormatter.date(from: "2003-03-20") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "Daniel", athleteLastName: "Brown", athleteDOB: dateFormatter.date(from: "2002-06-25") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Olivia", athleteLastName: "Martinez", athleteDOB: dateFormatter.date(from: "2004-01-18") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "Ethan", athleteLastName: "Gonzalez", athleteDOB: dateFormatter.date(from: "2000-12-10") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Emma", athleteLastName: "Rodriguez", athleteDOB: dateFormatter.date(from: "2003-09-28") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "William", athleteLastName: "Lopez", athleteDOB: dateFormatter.date(from: "2001-07-07") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Madison", athleteLastName: "Hernandez", athleteDOB: dateFormatter.date(from: "2002-04-05") ?? Date(), athleteGender: .female),
            Athlete(athleteFirstName: "Noah", athleteLastName: "Perez", athleteDOB: dateFormatter.date(from: "2004-11-20") ?? Date(), athleteGender: .male),
            Athlete(athleteFirstName: "Chloe", athleteLastName: "Gomez", athleteDOB: dateFormatter.date(from: "2003-01-15") ?? Date(), athleteGender: .female)
        ]

        for athlete in exampleAthletes2 {
            carnival2.addAthlete(athlete)
        }
    }


    

}


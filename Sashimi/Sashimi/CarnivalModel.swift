//
//  CarnivalStruct.swift
//  Swim Carnival
//
//  Created by Tom Keir on 11/3/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var carnival: UTType {
        UTType(importedAs: "com.tomkeir.carnival")
    }
}

// Data type Gender
enum Gender: Codable {
    case male
    case female
    case mixed
}

// Data type Athlete
struct Athlete: Hashable, Identifiable, Codable {
    var athleteFirstName: String
    var athleteLastName: String
    var athleteDOB: Date
    var athleteGender: Gender
    var id = UUID()
}

// Data type Event
struct Event: Hashable, Identifiable, Codable {
    var eventName: String
    var eventGender: Gender
    var eventAgeGroup: Int? // Optional value because an event may be mixed-ages. If there is no value, this is the case.
    var scores: [Athlete: Time]?
    var ranks: [String: Int] = [:] // Scoring data
    var id = UUID()
}

struct Time: Hashable, Codable {
    var minutes: Int
    var seconds: Int
    var milliseconds: Int
}

class Carnival: ObservableObject, Identifiable, Codable, Hashable {
    
    static func == (lhs: Carnival, rhs: Carnival) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @Published var name: String
    @Published var date: Date
    @Published var athletes: [Athlete]
    @Published var events: [Event]
    
    @Published var fileURL: URL? // Use URL instead of String for file address
    
    
    var id = UUID()
    
    init(name: String, date: Date, fileURL: URL? = nil) {
        self.name = name
        self.date = date
        self.athletes = []
        self.events = []
        self.fileURL = fileURL
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
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
        case athletes
        case events
        case id
        case fileURL // Change from fileAddress to fileURL
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        date = try container.decode(Date.self, forKey: .date)
        athletes = try container.decode([Athlete].self, forKey: .athletes)
        events = try container.decode([Event].self, forKey: .events)
        id = try container.decode(UUID.self, forKey: .id)
        fileURL = try container.decodeIfPresent(URL.self, forKey: .fileURL) // Decode URL instead of String
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(athletes, forKey: .athletes)
        try container.encode(events, forKey: .events)
        try container.encode(id, forKey: .id)
        try container.encode(fileURL, forKey: .fileURL) // Encode URL instead of String
    }
}



class CarnivalManager: ObservableObject {
    
    //allows data manipulation from any area of the app by using CarnivalManager.shared. ...
    static let shared = CarnivalManager()
    
    @Published var carnivals: [Carnival]
    @Published var selectedCarnival: Carnival?
    
    private init() {
        self.carnivals = []
    }
    
    func createCarnival(name: String, date: Date, fileAddress: String?) -> Carnival {
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
        let carnival1 = CarnivalManager.shared.createCarnival(name: "KHC Swimming Carnival", date: Date(), fileAddress: nil)

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

        let carnival2 = CarnivalManager.shared.createCarnival(name: "BHC Swimming Carnival", date: Date(), fileAddress: nil)

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
    
    func loadCarnival(completion: @escaping (Error?) -> Void) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "carnival")!]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false

        panel.begin { response in
            guard response == .OK, let url = panel.url else {
                completion(nil)
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                var importedCarnival = try decoder.decode(Carnival.self, from: data)
                importedCarnival.fileURL = url

                if self.carnivals.contains(where: { $0.id == importedCarnival.id }) {
                    completion(NSError(domain: "CarnivalManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Carnival is already open."]))
                } else {
                    self.carnivals.append(importedCarnival)
                    completion(nil)
                }
            } catch {
                completion(error)
            }
        }
    }


        func saveCarnival(_ carnival: Carnival) {
            let panel = NSSavePanel()
            panel.allowedContentTypes = [.carnival]
            panel.canCreateDirectories = true
            panel.nameFieldStringValue = "\(carnival.name).carnival"

            panel.begin { response in
                guard response == .OK, let url = panel.url else {
                    return
                }

                do {
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .iso8601
                    let data = try encoder.encode(carnival)
                    try data.write(to: url)
                } catch {
                    print("Failed to save carnival: \(error)")
                }
            }
            
            
        }
    
    func saveChanges(for carnival: Carnival?) {
        guard let carnival = carnival, let fileURL = carnival.fileURL else {
            print("No carnival to save or missing file URL.")
            return
        }

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(carnival)
            try data.write(to: fileURL)
            print("Carnival saved successfully.")
        } catch {
            print("Failed to save carnival: \(error)")
        }
    }

}

extension Carnival {
    func generateAthletesCSV() -> String {
        var csvText = ""
        for athlete in athletes {
            let gender = athlete.athleteGender == .male ? "Male" : athlete.athleteGender == .female ? "Female" : "Mixed"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dob = dateFormatter.string(from: athlete.athleteDOB)
            let row = "\(athlete.athleteFirstName),\(athlete.athleteLastName),\(dob),\(gender.lowercased())\n"
            csvText.append(row)
        }
        return csvText
    }
}




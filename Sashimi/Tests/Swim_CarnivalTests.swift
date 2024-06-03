//
//  Swim_CarnivalTests.swift
//  Swim CarnivalTests
//
//  Created by Tom Keir on 4/3/2024.
//

import XCTest
@testable import Sashimi

class CarnivalTests: XCTestCase {
    
    // MARK: - Test Carnival Functions
    
    func testCreateCarnival() {
        let carnivalManager = CarnivalManager.shared
        let carnival = carnivalManager.createCarnival(name: "Test Carnival", date: Date(), fileAddress: nil)
        XCTAssertNotNil(carnival)
        XCTAssertEqual(carnival.name, "Test Carnival")
    }
    
    func testDeleteCarnival() {
        let carnivalManager = CarnivalManager.shared
        let carnival = carnivalManager.createCarnival(name: "Test Carnival", date: Date(), fileAddress: nil)
        let initialCount = carnivalManager.carnivals.count
        carnivalManager.deleteCarnival(carnival)
        XCTAssertEqual(carnivalManager.carnivals.count, initialCount - 1)
    }
    
    
    // MARK: - Test Event Functions
    
    func testCreateEvent() {
        let carnivalManager = CarnivalManager.shared
        let carnival = carnivalManager.createCarnival(name: "Test Carnival", date: Date(), fileAddress: nil)
        let event = carnivalManager.createEvent(carnival: carnival, name: "Test Event", gender: .male, age: 18)
        XCTAssertNotNil(event)
        XCTAssertEqual(event.eventName, "Test Event")
    }
    
    func testUpdateEvent() {
        let carnivalManager = CarnivalManager.shared
        let carnival = carnivalManager.createCarnival(name: "Test Carnival", date: Date(), fileAddress: nil)
        let event = carnivalManager.createEvent(carnival: carnival, name: "Test Event", gender: .male, age: 18)
        carnivalManager.updateEvent(event: event, newName: "Updated Event", newGender: .female, newAge: 21)
        XCTAssertEqual(event.eventName, "Updated Event")
        XCTAssertEqual(event.eventGender, .female)
        XCTAssertEqual(event.eventAgeGroup, 21)
    }
    
    // Add more tests for other Event functions as needed
    
    // MARK: - Test Athlete Functions
    
    func testCreateAthlete() {
        let carnivalManager = CarnivalManager.shared
        let carnival = carnivalManager.createCarnival(name: "Test Carnival", date: Date(), fileAddress: nil)
        let athlete = carnivalManager.createAthlete(carnival: carnival, firstName: "John", lastName: "Doe", DOB: Date(), gender: .male)
        XCTAssertNotNil(athlete)
        XCTAssertEqual(athlete.athleteFirstName, "John")
        XCTAssertEqual(athlete.athleteLastName, "Doe")
    }
    
    func testUpdateAthlete() {
        let carnivalManager = CarnivalManager.shared
        let carnival = carnivalManager.createCarnival(name: "Test Carnival", date: Date(), fileAddress: nil)
        let athlete = carnivalManager.createAthlete(carnival: carnival, firstName: "John", lastName: "Doe", DOB: Date(), gender: .male)
        carnivalManager.updateAthlete(athlete: athlete, newFirstName: "Jane", newLastName: "Smith", newGender: .female, newDOB: Date())
        XCTAssertEqual(athlete.athleteFirstName, "Jane")
        XCTAssertEqual(athlete.athleteLastName, "Smith")
        XCTAssertEqual(athlete.athleteGender, .female)
    }
    
    // Add more tests for other Athlete functions as needed
}

class ScoringTests: XCTestCase {
    
    // MARK: - Test Event Scoring Functions
    
    func testRankAthletes() {
        var event = Event(eventName: "Test Event", eventGender: .male, eventAgeGroup: 18)
        let athlete1 = Athlete(athleteFirstName: "John", athleteLastName: "Doe", athleteDOB: Date(), athleteGender: .male)
        let athlete2 = Athlete(athleteFirstName: "Jane", athleteLastName: "Smith", athleteDOB: Date(), athleteGender: .female)
        let athlete3 = Athlete(athleteFirstName: "Michael", athleteLastName: "Johnson", athleteDOB: Date(), athleteGender: .male)
        
        let time1 = Time(minutes: 1, seconds: 10, milliseconds: 500)
        let time2 = Time(minutes: 1, seconds: 12, milliseconds: 200)
        let time3 = Time(minutes: 1, seconds: 11, milliseconds: 800)
        
        event.results[athlete1] = time1
        event.results[athlete2] = time2
        event.results[athlete3] = time3
        
        let rankedAthletes = event.rankAthletes()
        XCTAssertEqual(rankedAthletes.count, 3)
        XCTAssertEqual(rankedAthletes[0], athlete1)
        XCTAssertEqual(rankedAthletes[1], athlete3)
        XCTAssertEqual(rankedAthletes[2], athlete2)
    }
    
    func testCalculateEventRanks() {
        var event = Event(eventName: "Test Event", eventGender: .male, eventAgeGroup: 18)
        let athlete1 = Athlete(athleteFirstName: "John", athleteLastName: "Doe", athleteDOB: Date(), athleteGender: .male)
        let athlete2 = Athlete(athleteFirstName: "Jane", athleteLastName: "Smith", athleteDOB: Date(), athleteGender: .female)
        let athlete3 = Athlete(athleteFirstName: "Michael", athleteLastName: "Johnson", athleteDOB: Date(), athleteGender: .male)
        
        let time1 = Time(minutes: 1, seconds: 10, milliseconds: 500)
        let time2 = Time(minutes: 1, seconds: 12, milliseconds: 200)
        let time3 = Time(minutes: 1, seconds: 11, milliseconds: 800)
        
        event.results[athlete1] = time1
        event.results[athlete2] = time2
        event.results[athlete3] = time3
        
        event.calculateEventRanks()
        
        XCTAssertEqual(event.ranks.count, 3)
        XCTAssertEqual(event.ranks["John Doe"], 1)
        XCTAssertEqual(event.ranks["Michael Johnson"], 2)
        XCTAssertEqual(event.ranks["Jane Smith"], 3)
    }

}

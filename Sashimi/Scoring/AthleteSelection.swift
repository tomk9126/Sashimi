//
//  ScoreEvent.swift
//  Swim Carnival
//
//  Created by Tom Keir on 11/3/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct AthleteSelection: View {
    let event: Event
    @State var carnival: Carnival
    @Binding var selectedAthletes: [Athlete]
    
    // Computed property to filter potential athletes based on event requirements
    var potentialAthletes: [Athlete] {
        return CarnivalManager.shared.carnivals.flatMap { $0.athletes }
            .filter { athlete in
                switch event.eventGender {
                case .male:
                    return athlete.athleteGender == .male
                case .female:
                    return athlete.athleteGender == .female
                case .mixed:
                    return true // Allow all genders
                }
            }
            .filter { athlete in
                if let eventAgeGroup = event.eventAgeGroup, let age = Calendar.current.dateComponents([.year], from: athlete.athleteDOB, to: carnival.date).year {
                    return age <= eventAgeGroup
                } else {
                    return true // If no age group specified, include all athletes
                }
            }
    }
    
    var body: some View {
        VStack {

            HStack(spacing: 20) {
                VStack {
                    Text("Selected Athletes")
                        .font(.headline)
                    List {
                        ForEach(selectedAthletes, id: \.id) { athlete in
                            Text("\(athlete.athleteFirstName) \(athlete.athleteLastName)")
                                .onDrag { NSItemProvider(object: "\(athlete.id.uuidString)" as NSString) }
                        }
                        
                    }.listStyle(.bordered).alternatingRowBackgrounds()
                }
                .onDrop(of: [UTType.text], delegate: PotentialAthleteDropDelegate(selectedAthletes: $selectedAthletes))
                
                Image(systemName: "arrow.left")
                
                VStack {
                    Text("Potential Athletes")
                        .font(.headline)
                    List {
                        ForEach(potentialAthletes, id: \.id) { athlete in
                            if selectedAthletes.contains(athlete) {
                                Text("\(athlete.athleteFirstName) \(athlete.athleteLastName)")
                                    .opacity((selectedAthletes.contains(athlete)) ? 0.5 : 1.0)
                            } else {
                                Text("\(athlete.athleteFirstName) \(athlete.athleteLastName)")
                                    .onDrag { NSItemProvider(object: "\(athlete.id.uuidString)" as NSString) }
                            }
       
                        }
                    }.listStyle(.bordered).alternatingRowBackgrounds()
                }.onDrop(of: [UTType.text], delegate: AthleteDropDelegate(selectedAthletes: $selectedAthletes))
            }
            
            Text("Drag and drop names from 'Potential Athletes' to 'Selected Athletes'")
                .padding(.vertical, 3.0)
        }
    }
}

struct AthleteDropDelegate: DropDelegate {
    @Binding var selectedAthletes: [Athlete]
    
    func performDrop(info: DropInfo) -> Bool {
        guard let droppedItem = info.itemProviders(for: [UTType.text]).first else { return false }
        droppedItem.loadObject(ofClass: NSString.self) { provider, error in
            guard error == nil, let athleteID = provider as? String else { return }
            if let athlete = self.athlete(withID: athleteID) {
                DispatchQueue.main.async {
                    if let index = self.selectedAthletes.firstIndex(of: athlete) {
                        self.selectedAthletes.remove(at: index)
                    }
                }
            }
        }
        return true
    }
    
    
    private func athlete(withID athleteID: String) -> Athlete? {
        return CarnivalManager.shared.carnivals
            .flatMap { $0.athletes }
            .first { $0.id.uuidString == athleteID }
    }
}

struct PotentialAthleteDropDelegate: DropDelegate {
    @Binding var selectedAthletes: [Athlete]
    
    func performDrop(info: DropInfo) -> Bool {
        guard let droppedItem = info.itemProviders(for: [UTType.text]).first else { return false }
        droppedItem.loadObject(ofClass: NSString.self) { provider, error in
            guard error == nil, let athleteID = provider as? String else { return }
            if let athlete = self.athlete(withID: athleteID) {
                DispatchQueue.main.async {
                    if !self.selectedAthletes.contains(athlete) {
                        self.selectedAthletes.append(athlete)
                    }
                }
            }
        }
        return true
    }
    
    
    
    private func athlete(withID athleteID: String) -> Athlete? {
        return CarnivalManager.shared.carnivals
            .flatMap { $0.athletes }
            .first { $0.id.uuidString == athleteID }
    }
}



#Preview {
    @State var carnival = Carnival(name: "Carnival", date: Date.now)
    @State var event = Event(eventName: "Event Name", eventGender: .mixed, eventAgeGroup: 21)
    return ScoreEvent(event: $event, carnival: $carnival)
        .padding()
}

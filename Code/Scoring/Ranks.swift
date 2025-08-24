//
//  Ranks.swift
//  Sashimi
//
//  Created by Tom Keir on 30/5/2024.
//

import SwiftUI
import PDFKit

struct Ranks: View {
    @State var event: Event
    @ObservedObject var carnival: Carnival
    @Environment(\.dismiss) var dismiss

    func rank(athlete: Athlete) -> String {
        let athleteFullName = athlete.athleteFirstName + " " + athlete.athleteLastName
        return String(event.ranks[athleteFullName]!)
    }
    var body: some View {
        ZStack {
            VStack {
                Text("Rankings for \(event.eventName)")
                    .font(.headline)
                    
                Text(carnival.name)
                    .font(.footnote)
                    .padding(.bottom)

                Table(event.rankAthletes().sorted(by: { athlete1, athlete2 in
                    guard let rank1 = event.ranks["\(athlete1.athleteFirstName) \(athlete1.athleteLastName)"],
                          let rank2 = event.ranks["\(athlete2.athleteFirstName) \(athlete2.athleteLastName)"] else {
                        return false
                    }
                    return rank1 < rank2
                })) {
                    TableColumn("Rank") { athlete in
                        HStack{
                            let athleteRank = rank(athlete: athlete)
                            Text("\(athleteRank)")
                            switch athleteRank {
                            case "1":
                                Image(systemName: "medal.fill")
                                    .foregroundStyle(.yellow)
                            case "2":
                                Image(systemName: "medal.fill")
                                    .foregroundStyle(.gray)
                            case "3":
                                Image(systemName: "medal.fill")
                                    .foregroundStyle(.brown)
                            default:
                                EmptyView()
                            }
                        }
                    }
                    TableColumn("Name") { athlete in
                        Text("\(athlete.athleteFirstName) \(athlete.athleteLastName)")
                            .font(.headline)
                    }
                    
                    TableColumn("Time") { athlete in
                        if let time = event.results[athlete] {
                            Text("Time: \(time.minutes)'\(time.seconds)''\(time.milliseconds)")
                                .font(.subheadline)
                        } else {
                            Text("Time: -") // Display "-" if time is not available
                                .font(.subheadline)
                        }
                    }
                }
                
                .tableStyle(.bordered)
                
                HStack {
                    Button("Dismiss", systemImage: "xmark") {
                        dismiss()
                    }
                    Spacer()
                    Button("Export", systemImage: "square.and.arrow.up") {
                        exportText()
                    }
                    .disabled(event.ranks.isEmpty)
                    .help("Export the rank list as plain text.")
                }
            }
            .frame(width: 400, height: 400)
            .padding()
        }
        
        
    }
    
    
    private func exportText() {
        // Save text to file
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.text]
        savePanel.begin { result in
            if result == .OK {
                guard let url = savePanel.url else { return }
                do {
                    try generateTextData().write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    print("Error exporting text: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func generateTextData() -> String {
        // Generate plain text representation
        var text = "Rankings for \(event.eventName)\n\n"
        for (athleteName, rank) in event.ranks {
            text += "\(rank). \(athleteName)"
            if let athlete = event.results.keys.first(where: { $0.athleteFirstName + " " + $0.athleteLastName == athleteName }),
               let time = event.results[athlete] {
                // The following Image() calls do not make sense in a String context and are omitted
                text += " - Time: \(time.minutes)'\(time.seconds)''\(time.milliseconds)\n"
            } else {
                text += " - Time: -\n"
            }
        }
        return text
    }
}


#Preview {
    // Set up preview data
    let carnival = Carnival(name: "Preview Carnival", date: Date())
    
    let athlete1 = Athlete(athleteFirstName: "Mark", athleteLastName: "Smith", athleteDOB: Date(), athleteGender: .male)
    let athlete2 = Athlete(athleteFirstName: "Sarah", athleteLastName: "Jones", athleteDOB: Date(), athleteGender: .female)
    let athlete3 = Athlete(athleteFirstName: "Alex", athleteLastName: "Brown", athleteDOB: Date(), athleteGender: .male)
    let athlete4 = Athlete(athleteFirstName: "John", athleteLastName: "Appleseed", athleteDOB: Date(), athleteGender: .male)
    
    carnival.addAthlete(athlete1)
    carnival.addAthlete(athlete2)
    carnival.addAthlete(athlete3)
    carnival.addAthlete(athlete4)
    
    var previewEvent = Event(eventName: "100m Freestyle", eventGender: .mixed)
    previewEvent.results[athlete1] = Time(minutes: 1, seconds: 10, milliseconds: 20)
    previewEvent.results[athlete2] = Time(minutes: 1, seconds: 9, milliseconds: 80)
    previewEvent.results[athlete3] = Time(minutes: 1, seconds: 14, milliseconds: 15)
    previewEvent.results[athlete4] = Time(minutes: 1, seconds: 14, milliseconds: 20)
    previewEvent.calculateEventRanks()
    
    return Ranks(event: previewEvent, carnival: carnival)
}


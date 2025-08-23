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
                    .padding(.bottom)

                Table(event.rankAthletes().sorted(by: { athlete1, athlete2 in
                    guard let rank1 = event.ranks["\(athlete1.athleteFirstName) \(athlete1.athleteLastName)"],
                          let rank2 = event.ranks["\(athlete2.athleteFirstName) \(athlete2.athleteLastName)"] else {
                        return false
                    }
                    return rank1 < rank2
                })) {
                    TableColumn("Rank") { athlete in
                        Text("\(rank(athlete: athlete))")
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
                text += " - Time: \(time.minutes)'\(time.seconds)''\(time.milliseconds)\n"
            } else {
                text += " - Time: -\n"
            }
        }
        return text
    }
}


#Preview {
    CarnivalManager.shared.exampleUsage()
    return Ranks(event: Event(eventName: "", eventGender: .mixed), carnival: CarnivalManager.shared.carnivals[0])
}

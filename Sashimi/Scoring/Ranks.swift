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


    var body: some View {
        VStack {
            Text("Rankings for \(event.eventName)")
                .font(.headline)
                .padding(.bottom)

            Table(event.rankAthletes()) {
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
        }
        .padding()
        .toolbar {
            ToolbarItemGroup {
                Button("Export", systemImage: "square.and.arrow.up") {
                    exportText()
                }
                .help("Export the rank list as plain text.")
            }
        }
    }
    
    
    private func exportText() {
        // Save text to file
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["txt"]
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
    return Ranks(event: Event(eventName: "", eventGender: .male), carnival: CarnivalManager.shared.carnivals[0])
}

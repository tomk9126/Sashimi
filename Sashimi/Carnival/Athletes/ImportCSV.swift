//
//  ImportCSV.swift
//  Sashimi
//
//  Created by Tom Keir on 19/6/2024.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

class ImportCSV {
    @ObservedObject var carnivalManager = CarnivalManager.shared
    var importErrors: [String] = []
    
    func importCSV(from file: URL, to carnivalID: Carnival.ID) {
        guard let carnival = carnivalManager.carnivals.first(where: { $0.id == carnivalID }) else {
            importErrors.append("Carnival not found")
            return
        }
        
        let gotAccess = file.startAccessingSecurityScopedResource()
        defer {
            file.stopAccessingSecurityScopedResource()
        }
        guard gotAccess else {
            importErrors.append("Failed to access the file")
            return
        }
        
        do {
            let data = try Data(contentsOf: file)
            guard let content = String(data: data, encoding: .utf8) else {
                importErrors.append("Failed to decode the CSV file")
                return
            }
            let rows = content.components(separatedBy: .newlines)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // CSV date format
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.count == 4 {
                    // Decode date of birth
                    let dob = dateFormatter.date(from: columns[2])
                    
                    // Decode gender
                    var gender: Gender
                    if columns[3].lowercased() == "male" {
                        gender = .male
                    } else if columns[3].lowercased() == "female" {
                        gender = .female
                    } else {
                        gender = .mixed
                    }
                    
                    if let dob = dob {
                        let newAthlete = Athlete(athleteFirstName: columns[0], athleteLastName: columns[1], athleteDOB: dob, athleteGender: gender)
                        carnival.athletes.append(newAthlete)
                    } else {
                        importErrors.append("Invalid date format for athlete: \(columns)")
                    }
                } else {
                    importErrors.append("Invalid data format for athlete: \(columns)")
                }
            }
            
            if !importErrors.isEmpty {
                importErrors.append("View 'Help' on data formatting.")
            }
        } catch {
            importErrors.append("Error reading file: \(error.localizedDescription)")
        }
    }
    
    func selectAndImportCSV(for carnivalID: Carnival.ID) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.allowedFileTypes = [UTType.commaSeparatedText.identifier]
        
        if openPanel.runModal() == .OK, let url = openPanel.url {
            importCSV(from: url, to: carnivalID)
        }
    }
}

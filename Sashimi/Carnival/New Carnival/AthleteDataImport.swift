//
//  AthleteDataImport.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct AthleteDataImport: View {
    @State private var isImporting = false
    @Binding var carnival: Carnival
    @State private var selection: Athlete.ID?
    
    @State private var importErrors: [String] = []
    
    @State private var showAlert = false
    @State private var showingSearch = false
    @State private var showingPopover = false
    @State var searchText = ""
    @State var tokens: [Gender] = []
        
    private var filteredAthletes: [Athlete] {
		guard !searchText.isEmpty else {
			return carnival.athletes
		}

		return carnival.athletes.filter { athlete in
			let athleteGenderString = athlete.athleteGender == .male ? "Male" : "Female"
			return athlete.athleteFirstName.lowercased().contains(searchText.lowercased()) ||
                       athlete.athleteLastName.lowercased().contains(searchText.lowercased()) ||
                       athleteGenderString.lowercased() == searchText.lowercased()
		}
	}
        
    var body: some View {
        NavigationStack {
            VStack {
				HStack {
                    Spacer()
                    Button("Import (.csv)", systemImage: "square.and.arrow.up", role: .cancel) {
                        isImporting.toggle()
                    }
                    SearchBar(text: $searchText)
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
				Table(filteredAthletes, selection: $selection) {
                    TableColumn("First Name") { athlete in
                        TextField("", text: Binding(
                            get: { athlete.athleteFirstName },
                            set: { newValue in
                            if let index = carnival.athletes.firstIndex(where: { $0.id == athlete.id }) {
                                carnival.athletes[index].athleteFirstName = newValue
                            }
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                TableColumn("Last Name") { athlete in
					TextField("", text: Binding(
						get: { athlete.athleteLastName },
						set: { newValue in
						if let index = carnival.athletes.firstIndex(where: { $0.id == athlete.id }) {
								carnival.athletes[index].athleteLastName = newValue
							}
						}
						))
						.textFieldStyle(.roundedBorder)
				}
				TableColumn("Gender") { athlete in
					Text(athlete.athleteGender == .male ? "Male" : "Female")
				}
			}
			.tableStyle(.bordered)
			.padding(.bottom, 24)
			.overlay(alignment: .bottom, content: {
				VStack(alignment: .leading, spacing: 0) {
					Divider()
					HStack {
						HStack(spacing: 0) {
							GradientButton(glyph: "plus") {
								let newAthlete = Athlete(athleteFirstName: "First", athleteLastName: "Last", athleteDOB: Date(), athleteGender: .male)
								carnival.athletes.append(newAthlete)
								selection = newAthlete.id // Update selection to the new athlete
							}
							.keyboardShortcut(.defaultAction) // Set default action (Enter key)
							.padding(.trailing, 8)
                                
							GradientButton(glyph: "minus") {
								// Remove selected athletes
								if let selectedAthleteId = selection {
									carnival.athletes.removeAll { $0.id == selectedAthleteId }
									selection = nil // Clear selection after removing athlete
								}
							}
                                
							Spacer()
						}
						.buttonStyle(.borderless)
						HStack {
							Spacer()
							Text("\(carnival.athletes.count) Athletes")
							Spacer()
						}
						HStack {
							Spacer()
							HelpButton {
								showingPopover.toggle()
							}.popover(isPresented: $showingPopover) {
								HelpInformation()
									.padding()
									.frame(width: 350)
							}
                                
						}
                            
					}
                        
				}
				.background(
					Rectangle()
						.stroke()
						.opacity(0.04)
				)
				})
                
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.commaSeparatedText],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let files):
                files.forEach { file in
                    // Gain access to the directory
                    let gotAccess = file.startAccessingSecurityScopedResource()
                    defer {
                        // Release access
                        file.stopAccessingSecurityScopedResource()
                    }
                    guard gotAccess else { return }
                    do {
                        let data = try Data(contentsOf: file)
                        guard let content = String(data: data, encoding: .utf8) else {
                            importErrors.append("Failed to decode the CSV file")
                            return
                        }
                        let rows = content.components(separatedBy: .newlines)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd" //CSV date format

                        for row in rows {
                            let columns = row.components(separatedBy: ",")
                            if columns.count == 4 {
                                //decode date of birth
                                let dob = dateFormatter.date(from: columns[2])

                                //decode gender
                                var gender: Gender
                                if columns[3] == "male" {
                                    gender = .male
                                } else if columns[3] == "female" {
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
                    } catch {
                        importErrors.append("Error reading file: \(error.localizedDescription)")
                    }
                }
                if !importErrors.isEmpty {
                    importErrors.append("View 'Help' on data formatting.")
                    showAlert = true
                }
            case .failure(let error):
                importErrors.append("File importing failed with error: \(error.localizedDescription)")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Errors"),
                message: Text(importErrors.joined(separator: "\n")),
                dismissButton: .default(Text("OK")) {
                    importErrors.removeAll()
                }
            )
        }
    }
    
}

struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            if isEditing {
                TextField("Find Athletes...", text: $text)
                    .frame(width: 150)
                Button("Cancel", systemImage: "xmark") {
                    isEditing.toggle()
                }.keyboardShortcut(.defaultAction)
            } else {
                Button("Search", systemImage: "magnifyingglass") {
                    isEditing.toggle()
                }
            }
        }
    }
}

struct HelpButton: View {
	var action : () -> Void
	
	var body: some View {
		Button(action: action, label: {
			ZStack {
				Circle()
					.strokeBorder(Color(NSColor.controlShadowColor), lineWidth: 0.5)
					.background(Circle().foregroundColor(Color(NSColor.controlColor)))
					.shadow(color: Color(NSColor.controlShadowColor).opacity(0.3), radius: 1)
					.frame(width: 20, height: 20)
				Text("?").font(.system(size: 15, weight: .medium))
			}
			
		})
		.buttonStyle(PlainButtonStyle())
	}
}

struct GradientButton: View {
	var glyph: String
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			ZStack {
				Image(systemName: glyph)
					.fontWeight(.medium)
				Color.clear
					.frame(width: 24, height: 24)
			}
		}
		.buttonStyle(BorderlessButtonStyle())
	}
}

struct HelpInformation: View {
	var body: some View {
		VStack (alignment: .leading, spacing: 2.0){
			Text("Athletes are defined by a name, gender, and date of birth. These are necessary to make them race candidates.")
			Text("You may import a database of athletes via a .csv file. This files can be created in other programs or exported from another Sashimi carnival.")
			Text("For guidance on writing these databases, open the .csv template")
			HStack {
				Spacer()
				VStack {
					Button("Get .csv Template") { getAthletesTemplate() }
					Text("This will place a file in your downloads folder")
						.font(.subheadline)
				}
				Spacer()
			}
			
			
		}
	}
	
	func getAthletesTemplate() {
		let file = "\(UUID().uuidString).txt"
		let contents = "Some text..."
		
		let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let fileURL = dir.appendingPathComponent(file)
		
		do {
			try contents.write(to: fileURL, atomically: false, encoding: .utf8)
		}
		catch {
			print("Error: \(error)")
		}
	}
}

#Preview {
    @State var carnival = Carnival(name: "", date: Date.now)
    return AthleteDataImport(carnival: $carnival)
        .padding()
    
    
}

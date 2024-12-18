//
//  EditAthlete.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct EditAthlete: View {
    @Environment(\.dismiss) var dismiss

	@State var carnival: Carnival
    @State var athlete: Athlete
    
    @State private var isCreateButtonDisabled = true // Initially disabled
    
    
    var body: some View {
        VStack {
            Text("Edit Athlete")
                .font(.headline)
            Form {
                LabeledContent("Name:") {
                    HStack {
                        TextField("First Name:", text: $athlete.athleteFirstName)
                        TextField("Last Name:", text: $athlete.athleteLastName)
                    }
                    .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    DatePicker("Athlete DOB: ", selection: $athlete.athleteDOB, displayedComponents: [.date])
                }
                
                Divider()
                
                Picker(selection: $athlete.athleteGender, label: Text("Gender:")) {
                    Text("Male").tag(Gender.male)
                    Text("Female").tag(Gender.female)
                    
                }
                .pickerStyle(.inline)
                
                
            }
            .frame(width: 265)
            .onReceive([athlete.athleteFirstName].publisher) { _ in
                updateCreateButtonState() // Update state when checkbox states or eventName changes
            }
            Divider()
            
            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Edit") {
                    CarnivalManager.shared.updateAthlete(athlete: athlete, newFirstName: athlete.athleteFirstName, newLastName: athlete.athleteLastName, newGender: athlete.athleteGender, newDOB: athlete.athleteDOB)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(isCreateButtonDisabled)
            }
        }
        .padding(.all)
    }
    
    private func updateCreateButtonState() {
        // Enable button only if at least one checkbox is ticked and eventName is not empty
        isCreateButtonDisabled = athlete.athleteFirstName.isEmpty
    }
}

#Preview {
    let athlete = Athlete(athleteFirstName: "John", athleteLastName: "Smith", athleteDOB: Date.now, athleteGender: .male)
	return EditAthlete(carnival: Carnival(name: "", date: Date.now), athlete: athlete)
		.frame(width: 300, height: 200)
		.padding()
}

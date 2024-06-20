//
//  NewAthlete.swift
//  Swim Carnival
//
//  Created by Tom Keir on 11/3/2024.
//

import SwiftUI

struct NewAthlete: View {
    @Environment(\.dismiss) var dismiss

    @Binding var reopenAthleteSheet: Bool
    
    @State private var athleteFirstName = ""
    @State private var athleteLastName = ""
    @State private var athleteGender: Gender = .male
    @State private var athleteDOB = Date.now
    
    @State private var isCreateButtonDisabled = true // Initially disabled
    
    @State var carnival: Carnival
    
    var body: some View {
        VStack {
            Text("New Athlete")
                .font(.headline)
            Form {
                LabeledContent("Name:") {
                    HStack {
                        TextField("First Name:", text: $athleteFirstName)
                        TextField("Last Name:", text: $athleteLastName)
                    }
                    .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    DatePicker("Athlete DOB: ", selection: $athleteDOB, displayedComponents: [.date])
                }
                
                Divider()
                
                Picker(selection: $athleteGender, label: Text("Gender:")) {
                    Text("Male").tag(Gender.male)
                    Text("Female").tag(Gender.female)
                    
                }
                .pickerStyle(.inline)
                
                
            }
            .frame(width: 265)
            .onReceive([athleteFirstName, athleteLastName].publisher) { _ in
                updateCreateButtonState() // Update state when checkbox states or eventName changes
            }
            Divider()
            
            Toggle(isOn: $reopenAthleteSheet) {
                Text("Reopen this dialogue after creation.")
                Text("Instsntly create another Athlete")
                    .font(.subheadline)
            }
            
            
            HStack {
                Button("Cancel", role: .cancel) {
                    reopenAthleteSheet = false
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Create") {
                    createAthlete()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(isCreateButtonDisabled) // Disable based on condition
            }
        }
        .padding(.all)
    }
    
    private func createAthlete() {
        let newAthlete = Athlete(athleteFirstName: athleteFirstName, athleteLastName: athleteLastName, athleteDOB: athleteDOB, athleteGender: athleteGender)
        carnival.addAthlete(newAthlete)
    }
    
    private func updateCreateButtonState() {
        // Enable button only if at least one checkbox is ticked and eventName is not empty
        isCreateButtonDisabled = athleteFirstName.isEmpty
    }
}

#Preview {
    @State var reopenSheet = true
    return NewAthlete(reopenAthleteSheet: $reopenSheet, carnival: Carnival(name: "", date: Date.now))
}

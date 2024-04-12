//
//  NewEvent.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct NewEvent: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var male = false
    @State private var female = false
    @State private var mixed = false
    
    @State private var eventName = ""
    @State private var ageGroup = 12
    
    @State private var isCreateButtonDisabled = true // Initially disabled
    
    @State var carnival: Carnival
    
    var body: some View {
        Form {
            Section(header: Text("Create identical events for:")) {
                VStack(alignment: .leading) {
                    Toggle(isOn: $male) {
                        Text("Male")
                    }
                    .toggleStyle(.checkbox)
                    Toggle(isOn: $female) {
                        Text("Female")
                    }
                    .toggleStyle(.checkbox)
                    Toggle(isOn: $mixed) {
                        Text("Mixed")
                    }
                    .toggleStyle(.checkbox)
                }
            }
            
            Section(header: Text("Settings:")) {
                VStack(alignment: .leading) {
                    TextField("Event Name", text: $eventName)
                    Stepper(value: $ageGroup, in: 1...99) {
                        Text("Age Group: \(ageGroup)")
                    }
                }
            }
            
            HStack() {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                
                Button("Create") {
                    if male {
                        createEvent(gender: "Male")
                    }
                    if female {
                        createEvent(gender: "Female")
                    }
                    if mixed {
                        createEvent(gender: "Mixed")
                    }
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(isCreateButtonDisabled) // Disable based on condition
            }
        }
        .onReceive([male, female, mixed, eventName].publisher) { _ in
            updateCreateButtonState() // Update state when checkbox states or eventName changes
        }
        .frame(width: 300)
    }
    
    private func createEvent(gender: String) {
        let newEvent = Event(eventName: eventName, eventGender: gender, eventAgeGroup: "\(ageGroup)")
        carnival.addEvent(newEvent)
    }
    
    private func updateCreateButtonState() {
        // Enable button only if at least one checkbox is ticked and eventName is not empty
        isCreateButtonDisabled = !male && !female && !mixed || eventName.isEmpty
    }
}


#Preview {
    NewEvent(carnival: Carnival(name: "Carnival Name", date: Date.now))
}

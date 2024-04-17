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
    @State private var mixedAges = false
    @State private var ageGroup = 12
    
    
    @State private var isCreateButtonDisabled = true // Initially disabled
    
    @State var carnival: Carnival
    
    var body: some View {
        Form {
            TextField("Event Name:", text: $eventName)
            Divider()
            
            HStack {
                Toggle(isOn: $mixedAges) {}
                    .labelsHidden()
                .toggleStyle(.checkbox)
                TextField("Age Group: ", value: $eventName, formatter: NumberFormatter())
                    .disabled(!mixedAges)
                Stepper("Value", value: $ageGroup, in: 0...100)
                    .labelsHidden()
                    .disabled(!mixedAges)
                Spacer()
            }
            Divider()
            LabeledContent("Gender: ") {
                VStack (alignment: .leading){
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
            
            
            
        }
        .frame(width: 265)
        .onReceive([male, female, mixed, eventName].publisher) { _ in
            updateCreateButtonState() // Update state when checkbox states or eventName changes
            
        }
        HStack() {
            Button("Cancel", role: .cancel) {
                dismiss()
            }.keyboardShortcut(.cancelAction)
            
            Button("Create") {
                if male {
                    createEvent(gender: .male)
                }
                if female {
                    createEvent(gender: .female)
                }
                if mixed {
                    createEvent(gender: .mixed)
                }
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .disabled(isCreateButtonDisabled) // Disable based on condition
        }
        
    }
    
    private func createEvent(gender: Gender) {
        let newEvent = Event(eventName: eventName, eventGender: gender, eventAgeGroup: ageGroup)
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

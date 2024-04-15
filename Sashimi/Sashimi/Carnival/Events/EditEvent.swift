//
//  EditEvent.swift
//  Swim Carnival
//
//  Created by Tom Keir on 13/3/2024.
//

import SwiftUI

struct EditEvent: View {
    @Environment(\.dismiss) var dismiss
    
    @State var event: Event
    
    @State private var mixedAges = false
    @State private var ageGroupValue: Int = 0 // Default value for the age group
    
    var body: some View {
        Form() {
            Picker(selection: $event.eventGender, label: Text("Gender:")) {
                Text("Male").tag(Gender.male)
                Text("Female").tag(Gender.female)
                Text("Mixed").tag(Gender.mixed)
            }
            .pickerStyle(.inline)
            
            
            TextField(text: $event.eventName, prompt: Text("'100m freestyle'")) {
                Text("Event Name: ")
            }
            
            HStack {
                Toggle(isOn: $mixedAges) {}
                .toggleStyle(.checkbox)
                TextField("Age Group: ", value: $event.eventAgeGroup, formatter: NumberFormatter())
                    .disabled(!mixedAges)
                Stepper("Value", value: $ageGroupValue, in: 0...100)
                    .labelsHidden()
                    .disabled(!mixedAges)
                    .onChange(of: ageGroupValue) { newValue in
                        event.eventAgeGroup = newValue
                    }
                Spacer()
            }

        }
        .frame(width: 265)
        .padding([.top, .leading, .trailing])
        HStack() {
            Button("Cancel", role: .cancel) {
                dismiss()
            }.keyboardShortcut(.cancelAction)
            Button("Edit Event") {
                CarnivalManager.shared.updateEvent(event: event, newName: event.eventName, newGender: event.eventGender, newAge: event.eventAgeGroup)
                dismiss()
            }.keyboardShortcut(.defaultAction)
        }
        .padding(.all)
        
        
    }
}


#Preview {
    EditEvent(event: Event(eventName: "Name", eventGender: .male, eventAgeGroup: 21))
}

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

        VStack {
            Text("Edit Event '\(event.eventName)'")
                .font(.headline)
            Form() {
                TextField(text: $event.eventName, prompt: Text("'100m freestyle'")) {
                    Text("Event Name:")
                }
                Divider()
                HStack {
                    Toggle(isOn: $mixedAges) {}
                    .toggleStyle(.checkbox)
                    TextField("Age Group:", value: $event.eventAgeGroup, formatter: NumberFormatter())
                        .disabled(!mixedAges)
                    Stepper("Value", value: $ageGroupValue, in: 0...100)
                        .labelsHidden()
                        .disabled(!mixedAges)
                        .onChange(of: ageGroupValue) { oldOrder, newOrder in
                            event.eventAgeGroup = newOrder
                        }
                    Spacer()
                    
                }
                Divider()
                Picker(selection: $event.eventSex, label: Text("Sex:")) {
                    Text("Male").tag(Sex.male)
                    Text("Female").tag(Sex.female)
                    Text("Mixed").tag(Sex.mixed)
                }
                .pickerStyle(.inline)

            }
            .frame(width: 265)
            HStack() {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                Button("Edit Event") {
                    CarnivalManager.shared.updateEvent(event: event, newName: event.eventName, newSex: event.eventSex, newAge: event.eventAgeGroup)
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
            .formStyle(.grouped)
        }
        .padding(.all)
        
    }
    
}


#Preview {
    EditEvent(event: Event(eventName: "Name", eventSex: .male, eventAgeGroup: 21))
    
}

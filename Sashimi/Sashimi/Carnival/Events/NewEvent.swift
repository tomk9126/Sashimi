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
    
    @Binding var reopenEventSheet: Bool
    
    @State private var eventName = ""
    @State private var singleAge = false
    @State private var ageGroupSlider = 12
    
    @State private var isCreateButtonDisabled = true // Initially disabled
    
    @State var carnival: Carnival
    
    var body: some View {
        VStack {
            Text("New Event")
                .font(.headline)
            Form {
                TextField("Event Name:", text: $eventName)
                Divider()
                
                HStack {
                    Toggle(isOn: $singleAge) {}
                        .labelsHidden()
                        .toggleStyle(.checkbox)
                    TextField("Age Group:", value: $ageGroupSlider, formatter: NumberFormatter())
                        .disabled(!singleAge)
                    Stepper(value: $ageGroupSlider, in: 0...100) {
                        Text("Value")
                    }
                    .disabled(!singleAge)
                    .labelsHidden()
                }
                
                Divider()
                
                LabeledContent("Gender:") {
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
                
                
            }
            .frame(width: 265)
            .onReceive([male, female, mixed, eventName].publisher) { _ in
                updateCreateButtonState() // Update state when checkbox states or eventName changes
            }
            Divider()
            
            Toggle(isOn: $reopenEventSheet) {
                Text("Reopen this dialogue after creation.")
                Text("Supports faster creation")
                    .font(.subheadline)
            }
            
            
            HStack {
                Button("Cancel", role: .cancel) {
                    reopenEventSheet = false
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Create") {
                    createEvent()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(isCreateButtonDisabled) // Disable based on condition
            }
        }
        .padding(.all)
    }
    
    private func createEvent() {
        var genders: [Gender] = []
        
        if male { genders.append(.male) }
        if female { genders.append(.female) }
        if mixed { genders.append(.mixed) }
        
        let ageGroup: Int? = singleAge ? ageGroupSlider : nil
        
        for gender in genders {
            let newEvent = Event(eventName: eventName, eventGender: gender, eventAgeGroup: ageGroup)
            carnival.addEvent(newEvent)
        }
    }
    
    private func updateCreateButtonState() {
        // Enable button only if at least one checkbox is ticked and eventName is not empty
        isCreateButtonDisabled = !(male || female || mixed) || eventName.isEmpty
    }
}


#Preview {
    @State var showingNewEventSheet = true
    @State var carnival = Carnival(name: "", date: Date.now)
    
    return NewEvent(reopenEventSheet: $showingNewEventSheet, carnival: carnival)

}

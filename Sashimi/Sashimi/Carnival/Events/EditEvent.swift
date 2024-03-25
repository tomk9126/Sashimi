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
    
    @State private var male = false
    @State private var female = false
    @State private var mixed = false
    
    @State private var eventName = ""
    @State private var ageGroup = 12
    
    var body: some View {
        Form {
            Section(header: Text("Edit Event:")) {
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
                    TextField(text: $eventName, prompt: Text("Example: '100m freestyle'")) {
                        Text("Event Name: ")
                    }
                    TextField("Age Group: ", value: $ageGroup, formatter: NumberFormatter())
                    
                }
            }
            
            
            HStack() {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                Button("Edit") {
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
            
        
        }
        .frame(width: 300)
        .padding(.all)
        
        
    }
}

#Preview {
    EditEvent(event: Event(eventName: "Name", eventGender: "Gender", eventAgeGroup: "Age"))
}

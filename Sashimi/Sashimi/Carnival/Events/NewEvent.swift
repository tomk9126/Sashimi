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
                Button("Create") {
                    CarnivalManager.shared.createEvent(carnival: carnival, name: "Event", gender: "Gender", age: "Age")
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
            
        
        }
        .frame(width: 300)
        
        
        
    }
}

#Preview {
    NewEvent(carnival: Carnival(name: "Carnival Name", date: Date.now))
}

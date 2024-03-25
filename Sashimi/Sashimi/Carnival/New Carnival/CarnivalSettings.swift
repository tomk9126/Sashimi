//
//  CarnivalSettings.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct CarnivalSettings: View {
    
    @Binding var newCarnivalName: String
    @Binding var newCarnivalDate: Date
    
    var body: some View {
        NavigationStack {
            Section(header: Text("Carnival Settings:")) {
                VStack(alignment: .leading) {
                    TextField(text: $newCarnivalName, prompt: Text("Example: '100m freestyle'")) {
                        Text("Event Name: ")
                    }
                    DatePicker(
                            "Date",
                            selection: $newCarnivalDate,
                            displayedComponents: [.date]
                        )
                    
                }
            }
                
        }
        .frame(width: 250, height: 100)
        
    }
}

//#Preview {
//    CarnivalSettings()
//}

//
//  CarnivalSettings.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct CarnivalSettings: View {
    
    @State private var carnivalName = "Placeholder Name"
    @State private var carnivalDate = Date.now
    var body: some View {
        NavigationStack {
            Section(header: Text("Carnival Settings:")) {
                VStack(alignment: .leading) {
                    TextField(text: $carnivalName, prompt: Text("Example: '100m freestyle'")) {
                        Text("Event Name: ")
                    }
                    DatePicker(
                            "Date",
                            selection: $carnivalDate,
                            displayedComponents: [.date]
                        )
                    
                }
            }
                
        }
        .frame(width: 250, height: 100)
        
    }
}

#Preview {
    CarnivalSettings()
}

//
//  NewCarnival.swift
//  Swim Carnival
//
//  Created by Tom Keir on 14/3/2024.
//

import SwiftUI

struct NewCarnival: View {
    @State var newCarnivalName = "Placeholder Name"
    @State var newCarnivalDate = Date.now
    
    private let tabs = ["Athletes", "Settings"]
    @State private var selectedTab = 0
    
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        
        TabView() {
            Group {
                CarnivalSettings(newCarnivalName: $newCarnivalName, newCarnivalDate: $newCarnivalDate)
                    .padding()
            }
            .tabItem {
                Label("Carnival Settings", systemImage: "gearshape")
            }
            Group {
                AthleteDataImport()
                    .padding()
            }
            .tabItem {
                Label("Athletes", systemImage: "gearshape")
            }
            
            
        }
        

        VStack {
            HStack() {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                Button("Create") {
                    CarnivalManager.shared.createCarnival(name: newCarnivalName, date: newCarnivalDate)
                    print(CarnivalManager.shared.carnivals)
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
        }
    }
}


#Preview {
    NewCarnival()
}

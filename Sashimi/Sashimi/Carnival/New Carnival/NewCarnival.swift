//
//  NewCarnival.swift
//  Swim Carnival
//
//  Created by Tom Keir on 14/3/2024.
//

import SwiftUI

struct NewCarnival: View {
    @State var newCarnival = Carnival(name: "", date: Date.now)
    @State var newAthletes: [Athlete] = []
    private let tabs = ["Athletes", "Settings"]
    @State private var selectedTab = 0
    
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        
        TabView() {
            Group {
                CarnivalSettings(carnival: $newCarnival)
                    .padding()
            }
            .tabItem {
                Label("Carnival Settings", systemImage: "gearshape")
            }
            Group {
                AthleteDataImport(carnival: $newCarnival)
                    .padding()
            }
            .tabItem {
                Label("Athletes", systemImage: "person.fill")
            }
            
            
        }
        

        VStack {
            HStack() {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                    
                Button("Create") {
                    CarnivalManager.shared.carnivals.append(newCarnival)
                    //CarnivalManager.shared.carnivals.last!.athletes.append(contentsOf: newAthletes)
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

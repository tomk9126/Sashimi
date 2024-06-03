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
        
        NavigationStack {
            TabView(selection: $selectedTab) {
                CarnivalSettings(carnival: $newCarnival)
                    .tag(0)
                    .tabItem() {
                        Label("Carnival Settings", systemImage: "person.fill")
                    }
                    .padding()
                AthleteDataImport(carnival: $newCarnival)
                    .tag(1)
                    .tabItem() {
                        Label("Athletes", systemImage: "person.fill")
                    }
                    .padding()
            }

            VStack {
                HStack() {
                        
                    if selectedTab == 0 {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }.keyboardShortcut(.cancelAction)
                        Button("Next") { selectedTab = 1 }
                            .keyboardShortcut(.defaultAction)
                    } else {
                        Button("Back", role: .cancel) {
                            selectedTab = 0
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
        .frame(width: selectedTab == 0 ? 310 : 500,
                height: selectedTab == 0 ? 225 : 375)
        
    }
}


#Preview {
    NewCarnival()
        .padding()
        .frame(width: 700, height: 450)
}

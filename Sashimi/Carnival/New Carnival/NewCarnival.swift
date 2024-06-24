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
            }

            VStack {
                HStack() {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }.keyboardShortcut(.cancelAction)
                    Button("Create") {
                        CarnivalManager.shared.carnivals.append(newCarnival)
                        dismiss()
                    }.keyboardShortcut(.defaultAction)
                }
            }
        }
        .frame(width: 310, height: 270) 
    }
}


#Preview {
    NewCarnival()
        .padding()
        .frame(width: 320, height: 280)
}

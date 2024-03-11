//
//  AthletesList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 7/3/2024.
//

import SwiftUI

struct AthletesList: View {
    
    
    @State private var showingSheet = false
    
    @State private var selection: Set<Athlete.ID> = []
    var body: some View {
        NavigationStack {
            Table(Carnival().athletes, selection: $selection) {
                        TableColumn("Name", value: \.athleteFirstName)
                        TableColumn("Surname", value: \.athleteLastName)
                        TableColumn("DOB", value: \.athleteDOB)
                    }
                    .contextMenu {
                            Button {
                                // Score Event
                            } label: {
                                Label("Score...", systemImage: "list.clipboard")
                            }
                            Button {
                                // Edit Event Data
                            } label: {
                                Label("Edit...", systemImage: "pencil")
                            }
                            Button("Delete", role: .destructive) {
                                // Delete Event
                            }
                        }
        }
        .navigationTitle(Text("Carnival Name"))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                Button("Show Sheet", systemImage: "plus") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            NewAthlete()
                                .padding(.leading)
                        }
                        .labelStyle(.iconOnly)
                
                
                    
                
            }
        }
        
        
    }
}

#Preview {
    AthletesList()
}

//
//  AthletesList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 7/3/2024.
//

import SwiftUI

struct AthletesList: View {
    
    
    @State private var showingSheet = false
    @State private var showingPopover = false
    @State private var showingDeletionAlert = false
    
    @ObservedObject var carnival: Carnival
    
    @State private var selection: Set<Athlete.ID> = []
    
    var body: some View {
        NavigationStack {
            Table(carnival.athletes, selection: $selection) {
                        TableColumn("Name", value: \.athleteFirstName)
                        TableColumn("Surname", value: \.athleteLastName)
                        TableColumn("DOB", value: \.athleteDOB)
            }
            .contextMenu(forSelectionType: Athlete.ID.self) { RightClickedEvent in
                Button {
                    selection = RightClickedEvent
                    print("Selection Changed:", RightClickedEvent)
                    showingPopover.toggle()
                } label: {
                    Label("Score...", systemImage: "list.clipboard")
                }
                Button {
                    selection = RightClickedEvent
                    print("Selection Changed:", RightClickedEvent)
                    showingPopover.toggle()
                } label: {
                    Label("Edit...", systemImage: "pencil")
                }
                Button("Delete", role: .destructive) {
                    showingDeletionAlert = true
                }
            } primaryAction: { items in
                showingPopover.toggle()
            }
        }
    
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
        .popover(isPresented: self.$showingPopover) {
            EditAthlete()
        }
        
        
    }
}

//#Preview {
//    CarnivalManager.shared.exampleUsage()
//    AthletesList(carnival: CarnivalManager.shared.carnivals.first!)
//}

//
//  CarnivalView.swift
//  Swim Carnival
//
//  Created by Tom Keir on 7/3/2024.
//

import SwiftUI

struct CarnivalView: View {
    
    @ObservedObject var carnivalManager = CarnivalManager.shared
    @Binding var carnival: Carnival
    
    @State private var selectedTab = "Scoring"

    @State var showingPopover = false
    
    var body: some View {
        NavigationStack {
            if carnivalManager.carnivals.isEmpty {
                NoCarnivalSelected()
            } else {
                if selectedTab == "Scoring" {
                    EventsList(carnival: $carnival)
                }
                if selectedTab == "Athletes" {
                    AthletesList(carnival: $carnival)
                }
            }
        }
        
        .navigationTitle(carnivalManager.carnivals.isEmpty ? "Sashimi" : carnival.name)
        .toolbar {
            
            if !carnivalManager.carnivals.isEmpty {
                ToolbarItemGroup(placement: .navigation) {
                    Button("Settings", systemImage: "gear") {
                        showingPopover.toggle()
                    }.popover(isPresented: $showingPopover) {
                        CarnivalSettings(carnival: $carnival)
                            .padding()
                            .frame(width: 300, height: 200)
                    }
                    
                }
				
				//MARK: Scoring/Athletes tab selection
                ToolbarItemGroup(placement: .principal) {
                    VStack {
                        Picker("", selection: $selectedTab) {
                            Text("Scoring")
                                .tag("Scoring")
                            Text("Athletes")
                                .tag("Athletes")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
        }
        
    }
}


#Preview {
    CarnivalManager.shared.exampleUsage()
    struct PreviewWrapper: View {
        @State private var carnival: Carnival = CarnivalManager.shared.carnivals.first!
        var body: some View {
            CarnivalView(carnival: $carnival)
        }
    }
    return PreviewWrapper()
}

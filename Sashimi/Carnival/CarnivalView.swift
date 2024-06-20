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
    private let tabs = ["Scoring", "Athletes"]
    @State private var selectedTab = 0

    @State var showingPopover = false
    
    var body: some View {
        NavigationStack {
            if carnivalManager.carnivals.isEmpty {
                NoCarnivalSelected()
            } else {
                if selectedTab == 0 {
                    EventsList(carnival: $carnival)
                }
                if selectedTab == 1 {
                    AthletesList(carnival: $carnival, athletes: $carnival.athletes)
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
                ToolbarItemGroup(placement: .principal) {
                    VStack {
                        Picker("", selection: $selectedTab) {
                            ForEach(tabs.indices) { i in
                                Text(self.tabs[i]).tag(i)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top, 8)
                        Spacer()
                    }
                }
            }
        }
        
    }
}


#Preview {
    CarnivalManager.shared.exampleUsage()
    @State var carnival = CarnivalManager.shared.carnivals[0]
    return CarnivalView(carnival: $carnival)
}

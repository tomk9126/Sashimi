//
//  CarnivalView.swift
//  Swim Carnival
//
//  Created by Tom Keir on 7/3/2024.
//

import SwiftUI

struct CarnivalView: View {
    
    
    @State var carnival: Carnival
    
    private let tabs = ["Scoring", "Athletes"]
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            if selectedTab == 0 {
                EventsList(carnival: carnival)
            }
            if selectedTab == 1 {
                AthletesList()
            }
   
        }
        // Tab Bar
        .navigationTitle(carnival.name)
        .toolbar {
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
        
        // .frame(minWidth: 800, minHeight: 400)
        
    }
}

#Preview {
    let carnival = Carnival(name: "Sample Carnival", date: Date.now)
            return CarnivalView(carnival: carnival)
}

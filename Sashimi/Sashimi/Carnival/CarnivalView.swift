//
//  CarnivalView.swift
//  Swim Carnival
//
//  Created by Tom Keir on 7/3/2024.
//

import SwiftUI

struct CarnivalView: View {
    @ObservedObject var carnivalManager = CarnivalManager.shared
    @ObservedObject var carnival: Carnival
    private let tabs = ["Scoring", "Athletes"]
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            if carnivalManager.carnivals.isEmpty {
                NoCarnivalSelected()
            } else {
                if selectedTab == 0 {
                    EventsList(carnival: carnival)
                }
                if selectedTab == 1 {
                    AthletesList(carnival: carnival, athletes: $carnival.athletes)
                }
            }
        }
        .navigationTitle(carnival.name)
        .toolbar {
            if !carnivalManager.carnivals.isEmpty {
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
    return CarnivalView(carnival: CarnivalManager.shared.carnivals[0])
}

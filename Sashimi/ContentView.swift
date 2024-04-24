//
//  ContentView.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI


struct ContentView: View {

    @ObservedObject var carnivalManager = CarnivalManager.shared
    
    var body: some View {
        NavigationSplitView {
            CarnivalList()
        } detail: {
            NoCarnivalSelected()
            //This is the default detail view, but is overridden once a carnival is selected in CarnivalList()
        }
        
    }
}

#Preview {
    ContentView()
}

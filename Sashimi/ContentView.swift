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
            Button("Sample Data") {
                CarnivalManager.shared.exampleUsage()
            }
            CarnivalList()
        } detail: {
            NoCarnivalSelected()
        }
        
    }
}

#Preview {
    ContentView()
}

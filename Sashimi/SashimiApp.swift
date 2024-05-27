//
//  Swim_CarnivalApp.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

@main
struct Swim_CarnivalApp: App {
    @StateObject var carnivalManager = CarnivalManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(carnivalManager)
        }
        
    }
}



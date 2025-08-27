//
//  Swim_CarnivalApp.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

@main
struct Swim_CarnivalApp: App {
    @ObservedObject var carnivalManager = CarnivalManager.shared
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismissWindow
    
    @State var showingInspector = false
    
    var body: some Scene {
        Window("Welcome", id: "welcome") {
            WelcomeScreen()
                .environmentObject(carnivalManager)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        Window("Sashimi", id: "main") {
            ContentView(showingInspector: $showingInspector)
                .environmentObject(carnivalManager)
        }
        .commands {
            CommandMenu("View") {
                Toggle("Show Inspector", isOn: $showingInspector)
                    .keyboardShortcut("i", modifiers: [.command, .option])
            }
        }
    }
}

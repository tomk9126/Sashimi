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
    
    var body: some Scene {
        Window("Welcome", id: "welcome") {
            WelcomeScreen()
                .environmentObject(carnivalManager)
                .onAppear {
                    disableWindowControls(for: "Welcome")
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        Window("Sashimi", id: "main") {
            ContentView()
                .environmentObject(carnivalManager)
        }
   
    }
    
    
    private func disableWindowControls(for windowTitle: String) {
        // Delay execution to ensure the window is created
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// Identify Welcome Screen Window
            if let window = NSApplication.shared.windows.first(where: { $0.title == windowTitle }) {
				// Disable minimize/zoom button
                window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                window.standardWindowButton(.zoomButton)?.isEnabled = false
            }
        }
    }
}




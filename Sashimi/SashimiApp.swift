//
//  Swim_CarnivalApp.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

@main
struct Swim_CarnivalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            CommandGroup(after: .newItem) {
                Menu("New") {
                    Button("Carnival") { }.disabled(true)
                    Divider()
                    Button("Event") { }.disabled(true)
                    Button("Athlete") { }.disabled(true)
                }
                Button("Open Carnival...") { }.disabled(true)
                
            }
            CommandMenu("Carnival") {
                Button("Close Carnival without Saving") { }.disabled(true)
                Button("Close Carnival and Save Changes") { }.disabled(true)
                Divider()
                Button("Edit Carnival") { }.disabled(true)
                Button("Delete Carnival") { }.disabled(true)
                Divider()
                Button("Import Athletes") { }.disabled(true)
            }
            CommandMenu("Events") {
                Button("Score Event") { }.disabled(true)
                Divider()
                Button("Edit Event") { }.disabled(true)
                Button("Delete Event") { }.disabled(true)
            }
            CommandMenu("Athletes") {
                Button("New Athlete") { }.disabled(true)
                Section("Selected Athlete(s)") {
                    Button("Edit Athlete") { }.disabled(true)
                    Button("Delete Selected Athlete(s)") { }.disabled(true)
                }
                Section("Athletes List") {
                    Button("Athlete Search") { }.disabled(true)
                    Button("Export Athletes...") { }.disabled(true)
                }
                
            }
        }
    }
}





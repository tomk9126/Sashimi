//
//  GeneralPreferences.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

class ColorSchemeManager: ObservableObject {
    static let shared = ColorSchemeManager()
    @AppStorage("colorScheme") var selectedColorScheme: String = "system"
    
    func getPreferredColorScheme() -> ColorScheme? {
        switch selectedColorScheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil
        }
    }
}


struct GeneralPreferences: View {
    @StateObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        Text("No Settings.")
        /*
                List {
                    Section("Appearance") {
                        Picker(selection: $colorSchemeManager.selectedColorScheme, label: Text("Color Scheme")) {
                            Text("System").tag("system")
                            Text("Light").tag("light")
                            Text("Dark").tag("dark")
                        }
                        .pickerStyle(.menu)
                    }
                }
                .navigationTitle("Settings")
                .preferredColorScheme(colorSchemeManager.getPreferredColorScheme())
         */
            }
         
}

#Preview {
    GeneralPreferences()
}

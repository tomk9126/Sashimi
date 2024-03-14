//
//  PreferencesPane.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct PreferencesPane: View {
    var body: some View {
        
        TabView {
            Group {
               GeneralPreferences()
            }
            .tabItem {
                Label("General", systemImage: "gearshape")
            }
        
            
        }
        .frame(width: 300, height: 280)
        
    }
}

#Preview {
    PreferencesPane()
}


//
//  NewCarnival.swift
//  Swim Carnival
//
//  Created by Tom Keir on 14/3/2024.
//

import SwiftUI

struct NewCarnival: View {
    
    private let tabs = ["Athletes", "Settings"]
    @State private var selectedTab = 0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView {
            Group {
                CarnivalSettings()
            }
            .tabItem {
                Label("Carnival Settings", systemImage: "gearshape")
            }
            Group {
                AthleteDataImport()
            }
            .tabItem {
                Label("Athletes", systemImage: "gearshape")
            }
            
            
        }
        .frame(width: 500, height: 280)
        VStack {
            HStack() {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                Button("Create") {
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
        }
    }
}

#Preview {
    NewCarnival()
}

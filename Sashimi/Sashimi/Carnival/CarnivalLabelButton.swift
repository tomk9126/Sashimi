//
//  CarnivalLabelButton.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalLabelButton: View {
    
    @State private var showingDeletionAlert = false
    
    var carnival: Carnival
    
    var body: some View {
        HStack {
            Image("Swordfish")
                .resizable()
                .frame(width: 40, height: 40)
                .opacity(0.5)
            VStack (alignment: .leading) {
                Text(carnival.name)
                    .font(.headline)
                Text(carnival.date, format: .dateTime.day().month().year())
                   
            }
        }.contextMenu(ContextMenu(menuItems: {
            Button("Delete Carnival", systemImage: "bin", role: .destructive) {
                showingDeletionAlert.toggle()
            }
        }))
        .alert(
                "Delete Carnival?",
                isPresented: $showingDeletionAlert
            ) {
                Button("Delete", role: .destructive) {
                    CarnivalManager.shared
                        .deleteCarnival(carnival)
                }
            } message: {
                Text("This action cannot be undone.")
        }
    }
}

#Preview {
    CarnivalLabelButton(carnival: Carnival(name: "Carnival", date: Date.now))
}

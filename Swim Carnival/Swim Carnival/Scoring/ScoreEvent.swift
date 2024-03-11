//
//  ScoreEvent.swift
//  Swim Carnival
//
//  Created by Tom Keir on 11/3/2024.
//

import SwiftUI

struct ScoreEvent: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Score Event")
            Button("Cancel", role: .cancel) {
                dismiss()
            }.keyboardShortcut(.cancelAction)
        }
    }
    
}

#Preview {
    ScoreEvent()
}

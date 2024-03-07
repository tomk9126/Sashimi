//
//  NoCarnivalSelected.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct NoCarnivalSelected: View {
    var body: some View {
        VStack {
            Image("Swordfish")
                .resizable()
                .frame(width: 100, height: 100)
                .opacity(0.5)
            Text("Select a carnival from the sidebar.")
        }
    }
}

#Preview {
    NoCarnivalSelected()
}

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
            Image(systemName: "fish.fill")
            Text("Select a carnival from the sidebar.")
        }
    }
}

#Preview {
    NoCarnivalSelected()
}

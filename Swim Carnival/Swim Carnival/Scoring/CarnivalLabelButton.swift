//
//  CarnivalLabelButton.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalLabelButton: View {
    var body: some View {
        HStack {
            Image(systemName: "fish.fill")
            VStack (alignment: .leading) {
                Text("Carnival Name")
                    .font(.headline)
                Text("Date")
                   
            }
        }
    }
}

#Preview {
    CarnivalLabelButton()
}

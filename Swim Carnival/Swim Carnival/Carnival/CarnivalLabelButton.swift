//
//  CarnivalLabelButton.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalLabelButton: View {
    var carnivalName: String
    var body: some View {
        HStack {
            Image("Swordfish")
                .resizable()
                .frame(width: 40, height: 40)
                .opacity(0.5)
            VStack (alignment: .leading) {
                Text(carnivalName)
                    .font(.headline)
                Text("Date")
                   
            }
        }
    }
}

#Preview {
    CarnivalLabelButton(carnivalName: "Carnival Name")
}

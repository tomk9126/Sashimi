//
//  FileLabelButton.swift
//  Sashimi
//
//  Created by Tom Keir on 27/5/2024.
//

import SwiftUI

struct FileLabelButton: View {

    @Binding var carnival: Carnival

    var body: some View {
        HStack {
            Image("File Icon")
                .resizable()
                .scaledToFit()
                
            VStack(alignment: .leading) {
                Text(carnival.name)
                    .font(.headline)
                Text(carnival.fileURL?.absoluteString ?? "")
            }
            
        }
        .frame(height: 40)
        .contextMenu {
            Button("Clear from recents", systemImage: "xmark") {
                //
            }
            
        }

    }
}


#Preview {
    @State var carnival = Carnival(name: "Carnival", date: Date.now)
    return FileLabelButton(carnival: $carnival)
}

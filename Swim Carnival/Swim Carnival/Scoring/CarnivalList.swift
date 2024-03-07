//
//  CarnivalList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalList: View {
    var body: some View {
        
        NavigationStack {
            List() {
                NavigationLink {
                    CarnivalView()
                } label: {
                    CarnivalLabelButton()
                }
            }
            
        }
        .toolbar {
            ToolbarItemGroup() {
                Spacer()
                Button("New Carnival", systemImage: "plus") {
                        // Action
                        }
                        .labelStyle(.iconOnly)
                
        
                    
                
            }
        }
    }
}

#Preview {
    CarnivalList()
}

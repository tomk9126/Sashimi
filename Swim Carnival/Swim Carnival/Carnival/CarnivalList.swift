//
//  CarnivalList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalList: View {
    
    @State private var showingNewCarnivalSheet = false
    @State private var document: FileDocument?
    @State private var isImporting: Bool = false
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
                    showingNewCarnivalSheet.toggle()
                }
                .labelStyle(.iconOnly)
 
            }
        }
        .sheet(isPresented: $showingNewCarnivalSheet) {
            NewCarnival()
                .padding()
        }
        
    }
    
}

#Preview {
    CarnivalList()
}

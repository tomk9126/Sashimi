//
//  CarnivalList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalList: View {
    
    @ObservedObject var carnivalManagerObserved = CarnivalManager.shared
    @State private var refreshId = UUID()
    @State private var reloadList = UUID()
    
    @State private var showingNewCarnivalSheet = false
    @State private var document: FileDocument?
    @State private var isImporting: Bool = false
    
    var body: some View {
        
        NavigationStack {
            if carnivalManagerObserved.carnivals.count == 0 {
                VStack {
                    Text("No Carnivals.")
                }.padding()
                
            } else {
                List {
                    ForEach(carnivalManagerObserved.carnivals, id: \.self) { carnival in
                        NavigationLink(destination: CarnivalView(carnival: carnival)) {
                            CarnivalLabelButton(carnival: carnival)
                        }
                    }
                }.id(UUID())
            }
        }
        .toolbar {
            ToolbarItemGroup() {
                Spacer()
                Menu {
                    Button("New Carnival", systemImage: "plus") { showingNewCarnivalSheet.toggle() }
                    Button("Open Carnival", systemImage: "folder") {  }
                    
                } label: {
                    Label("Add Carnival", systemImage: "plus")
                }
 
            }
        }
        .sheet(isPresented: $showingNewCarnivalSheet) {
            NewCarnival()
                .padding()
        }
        
    }
    
}

#Preview {
    
    CarnivalManager.shared.createCarnival(name: "Summer Carnival", date: Date.now)
    CarnivalManager.shared.createCarnival(name: "Winter Carnival", date: Date.now)
            
    return CarnivalList()
}

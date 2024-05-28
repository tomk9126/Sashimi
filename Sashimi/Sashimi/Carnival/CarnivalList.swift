//
//  CarnivalList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers
import AppKit

struct CarnivalList: View {
    @EnvironmentObject var carnivalManager: CarnivalManager
    @Binding var showingNewCarnivalSheet: Bool
    

    var body: some View {
        if carnivalManager.carnivals.isEmpty {
            VStack {
                Text("No carnivals")
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            }.padding()
            .toolbar {
                ToolbarItemGroup() {
                    CarnivalToolbar(showingNewCarnivalSheet: $showingNewCarnivalSheet)
                }
            }
        } else {
            List($carnivalManager.carnivals, selection: $carnivalManager.selectedCarnival) { $carnival in
                NavigationLink(destination: CarnivalView(carnival: $carnival)) {
                    CarnivalLabelButton(carnival: $carnival)
                }
            }
            .toolbar {
                ToolbarItemGroup() {
                    CarnivalToolbar(showingNewCarnivalSheet: $showingNewCarnivalSheet)
                }
            }
        }
        
    }
}




//#Preview {
//    CarnivalManager.shared.exampleUsage()
//    @State var currentCarnival: Carnival? = nil
//    return ContentView(currentCarnival: $currentCarnival)
//}

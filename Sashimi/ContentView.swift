//
//  ContentView.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var carnivalManager: CarnivalManager

    var body: some View {
        CarnivalList()
    }
}

//#Preview {
    //@State var currentCarnival: Carnival? = nil
    //ContentView(currentCarnival: $currentCarnival)
//}

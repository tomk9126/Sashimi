//
//  CarnivalList.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalList: View {
    var body: some View {
        VStack {
            List() {
                NavigationLink {
                    EventsList()
                } label: {
                    CarnivalLabelButton()
                }
            }
            
        }
    }
}

#Preview {
    CarnivalList()
}

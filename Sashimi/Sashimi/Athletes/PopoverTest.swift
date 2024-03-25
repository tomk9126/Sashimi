//
//  PopoverTest.swift
//  Swim Carnival
//
//  Created by Tom Keir on 15/3/2024.
//

import SwiftUI

struct PopoverTest: View {
    @State var isPopover = false
    var body: some View {
        VStack {
            Button(action: { self.isPopover.toggle() }) {
                Image(nsImage: NSImage(named: NSImage.infoName) ?? NSImage())
            }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                     PopoverView()
            }.buttonStyle(PlainButtonStyle())
        }.frame(width: 800, height: 600)
    }
}

struct PopoverView: View {
    var body: some View {
        VStack {
            Text("Some text here ").padding()
            Button("Resume") {
            }
        }.padding()
    }
}

#Preview {
    PopoverTest()
}

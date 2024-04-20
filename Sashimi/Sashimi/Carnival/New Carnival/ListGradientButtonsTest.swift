//
//  ListGradientButtonsTest.swift
//  Sashimi
//
//  Created by Tom Keir on 20/4/2024.
//

import SwiftUI

struct TestView: View {
    @State private var selection: Int?

    struct GradientButton: View {
        var glyph: String
        var body: some View {
            ZStack {
                Image(systemName: glyph)
                    .fontWeight(.medium)
                Color.clear
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                List(selection: $selection) {
                    ForEach(0 ..< 5) { Text("Item \($0)") }
                }
                .padding(.bottom, 24)
                .overlay(alignment: .bottom, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Divider()
                        HStack(spacing: 0) {
                            Button(action: {}) {
                                GradientButton(glyph: "plus")
                            }
                            Divider().frame(height: 16)
                            Button(action: {}) {
                                GradientButton(glyph: "minus")
                            }
                            .disabled(selection == nil ? true : false)
                        }
                        .buttonStyle(.borderless)
                    }
                    .background(Rectangle().opacity(0.04))
                })
            }
        }
        .formStyle(.grouped)
    }
}
#Preview {
    TestView()
}

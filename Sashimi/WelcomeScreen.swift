//
//  WelcomeScreen.swift
//  Sashimi
//
//  Created by Tom Keir on 27/5/2024.
//

import SwiftUI
import Foundation
import Cocoa

struct WelcomeScreen: View {
    @EnvironmentObject var carnivalManager: CarnivalManager

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismissWindow
    
    @State private var showingNewCarnivalSheet = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    Image("Icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Sashimi Beta")
                        .font(.largeTitle)
                        .bold()
                    Text("Version " + (appVersion ?? ""))
                        .opacity(0.6)
                }.padding()
                
                VStack {
                    Button(action: {
                        showingNewCarnivalSheet.toggle()
                    }) {
                        Label("New Carnival", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }.help("Create a new Sashimi carnival")
                    
                    Button(action: {
                        CarnivalManager.shared.loadCarnival { error in
                            if let error = error {
                                // Handle error
                            }
                        }
                    }) {
                        Label("Open Carnival", systemImage: "folder")
                            .frame(maxWidth: .infinity)
                    }.help("Open an already existing Sashimi carnival")
                    
                    Button(action: {
                        openDocumentation()
                    }) {
                        Label("See Documentation", systemImage: "book")
                            .frame(maxWidth: .infinity)
                    }.help("View the Sashimi user guide")
                    
                    Button("Continue without a carnival") {
                        openWindow(id: "main")
                        dismissWindow()
                    }.buttonStyle(.plain)
                    .underline()
                }.controlSize(.large)
            }.padding()
            .sheet(isPresented: $showingNewCarnivalSheet) {
                NewCarnival()
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Allows sheet size to be altered by child views.
        }.frame(width: 360, height: 330)
    }
    
    private func openDocumentation() {
        if let url = Bundle.main.url(forResource: "User Guide", withExtension: "html") {
            NSWorkspace.shared.open(url)
        } else {
            print("Index.html file not found in Documentation folder")
        }
    }
}
#Preview {
    WelcomeScreen()
        .environmentObject(CarnivalManager.shared)
        
}

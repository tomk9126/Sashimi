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

	@State private var didError = false
	@State private var openError: String?
	
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    Image("SashimiIconLight")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Sashimi")
                        .font(.largeTitle)
                        .bold()
                    Text("Version " + (appVersion ?? ""))
                        .opacity(0.6)
                }
				.padding()
                
                VStack {
                    Button(action: {
                        openWindow(id: "main")
                        dismissWindow()
                    }) {
                        Label("Open Sashimi", systemImage: "arrow.right")
                            .frame(maxWidth: .infinity)
                    }
					.help("Open the Sashimi Interface")
                    
                    Button(action: {
                        openWindow(id: "main")
                        CarnivalManager.shared.loadCarnival { error in
                            if let error = error {
								openError = error.localizedDescription
								didError = true
                            }
                        }
                        dismissWindow()
                        
                    }) {
                        Label("Open Previous Carnival", systemImage: "folder")
                            .frame(maxWidth: .infinity)
                    }
					.help("Open an already existing Sashimi carnival")
					.alert(isPresented: $didError) {
						Alert(title: Text("Failed to open Carnival"), message: Text(openError ?? "An unknown error occured"))
					}
                    
                    Button(action: {
                        openDocumentation()
                    }) {
                        Label("See Documentation", systemImage: "book")
                            .frame(maxWidth: .infinity)
                    }
					.help("View the Sashimi user guide")
                    
                    
                }
				.controlSize(.large)
            }
			.padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Allows sheet size to be altered by child views.
        }
		.frame(width: 360, height: 330)
    }

    private func openDocumentation() {
        if let url = Bundle.main.url(forResource: "User Guide", withExtension: "html") {
            NSWorkspace.shared.open(url)
        } else {
            print("Documentation files not found. App may be damaged, consider reinstalling.")
        }
    }
}
#Preview {
    WelcomeScreen()
        .environmentObject(CarnivalManager.shared)
}

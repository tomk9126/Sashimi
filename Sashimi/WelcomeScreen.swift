//
//  WelcomeScreen.swift
//  Sashimi
//
//  Created by Tom Keir on 27/5/2024.
//

import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject var carnivalManager: CarnivalManager

    @State var showingNewCarnivalSheet = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    Image("Swordfish")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Sashimi")
                        .font(.largeTitle)
                        .bold()
                    Text("Version " + appVersion!)
                        .opacity(0.6)
                }.padding()
                
                VStack {
                    Button() {
                        showingNewCarnivalSheet.toggle()
                    } label: {
                        Label("New Carnival", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }.help("Create a new Sashimi carnival")
                    Button() {
                        CarnivalManager.shared.loadCarnival { error in
                            if let error = error {
                                //self.importErrors.append(error.localizedDescription)
                                //self.showImportAlert = true
                            }
                        }
                    } label: {
                        Label("Open Carnival", systemImage: "folder")
                            .frame(maxWidth: .infinity)
                    }.help("Open an already existing Sashimi carnival")
                    
                    Button() {
                        
                    } label: {
                        Label("See Documentation", systemImage: "book")
                            .frame(maxWidth: .infinity)
                    }.help("View the Sashimi user guide")
                }.controlSize(.large)
            }.padding()
                .sheet(isPresented: $showingNewCarnivalSheet) {
                    NewCarnival()
                        .padding()
                }
  
        }.frame(width: 360, height: 330)
    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(CarnivalManager.shared)
        
}

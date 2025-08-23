//
//  CarnivalLabelButton.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI

struct CarnivalLabelButton: View {
    @State private var showingDeletionAlert = false
    @State private var document: CarnivalFile?
    @State private var isExporting = false
    @State private var closeAfterSaving = false
    @State private var showingPopover = false
    @Binding var carnival: Carnival

    var body: some View {
        HStack {
            Image("Swordfish")
                .resizable()
                .scaledToFit()
                .opacity(0.5)
                
            VStack(alignment: .leading) {
                Text(carnival.name)
                    .font(.headline)
                Text(carnival.date, format: .dateTime.day().month().year())
            }
            Spacer()
            Button("Close Carnival", systemImage: "xmark") {
                showingDeletionAlert.toggle()
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .help("Close the Carnival.")
        }
        .frame(height: 40)
        .contextMenu {
            Button("Edit Carnival", systemImage: "pencil") {
                showingPopover.toggle()
            }
            Button("Close Carnival", systemImage: "bin", role: .destructive) {
                showingDeletionAlert.toggle()
            }
            Button("Save Carnival", systemImage: "file") {
                document = CarnivalFile(carnival: carnival)
                CarnivalManager.shared.saveCarnival(carnival)
                
            }
        }
        .popover(isPresented: $showingPopover) {
            CarnivalDetailView(carnival: $carnival)
        }
        .alert("Unsaved Changes", isPresented: $showingDeletionAlert) {
            Button("Save and Close") {
                closeAfterSaving = true
                document = CarnivalFile(carnival: carnival)
                CarnivalManager.shared.saveCarnival(carnival)
            }
            Button("Close Carnival", role: .destructive) {
                CarnivalManager.shared.deleteCarnival(carnival)
            }
        } message: {
            Text("You will lose these unsaved changes permanently")
        }
    }
}

struct CarnivalDetailView: View {
    @Binding var carnival: Carnival

    var body: some View {
        CarnivalSettings(carnival: $carnival)
            .padding()
    }
}

#Preview {
    CarnivalManager.shared.exampleUsage()
    
    struct PreviewWrapper: View {
        var body: some View {
            @State var carnival = CarnivalManager.shared.carnivals[0]
            CarnivalLabelButton(carnival: $carnival)
                .frame(width: 300)
                .padding()
        }
    }
    return PreviewWrapper()
    
}

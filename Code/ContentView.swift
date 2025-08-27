//
//  ContentView.swift
//  Swim Carnival
//
//  Created by Tom Keir on 4/3/2024.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers
import AppKit

struct ContentView: View {
    @EnvironmentObject var carnivalManager: CarnivalManager
    @Binding var showingInspector: Bool

    @State var showingNewCarnivalSheet = false
    @State private var isImporting: Bool = false
    @State private var importErrors: [String] = []
    @State private var showImportAlert = false

    @State private var selectedTab: String = "Scoring" // "Scoring" or "Athletes"

    var body: some View {
        HSplitView {
            NavigationSplitView {
                CarnivalList(showingNewCarnivalSheet: $showingNewCarnivalSheet)
            } detail: {
                if let carnival = carnivalManager.selectedCarnival {
                    if selectedTab == "Scoring" {
                        EventsList(carnival: bindingForSelectedCarnival())
                    } else {
                        AthletesList(carnival: bindingForSelectedCarnival())
                    }
                } else {
                    NoCarnivalSelected()
                }
            }
            .frame(minWidth: 205)
            .sheet(isPresented: $showingNewCarnivalSheet) {
                NewCarnival()
                    .padding()
            }
            .alert(isPresented: $showImportAlert) {
                Alert(
                    title: Text("Import Error"),
                    message: Text(importErrors.joined(separator: "\n")),
                    dismissButton: .default(Text("OK")) {
                        importErrors.removeAll()
                    }
                )
            }

            if showingInspector {
                InspectorView()
                    .frame(maxWidth: 240, maxHeight: .infinity)
                    .background(.thinMaterial)
            }
        }
        .toolbar {
            // Center picker for Scoring/Athletes
            ToolbarItem(placement: .principal) {
                if carnivalManager.selectedCarnival != nil {
                    Picker("", selection: $selectedTab) {
                        Text("Scoring").tag("Scoring")
                        Text("Athletes").tag("Athletes")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                    .help("Switch between viewing/scoring events and managing athletes.")
                }
            }

            // Controls just right of center, contextually
            ToolbarItemGroup(placement: .automatic) {
                // Flexible spacer to push controls right of center
                Spacer(minLength: 10)
                if carnivalManager.selectedCarnival != nil {
                    if selectedTab == "Scoring" {
                        EventsToolbar(carnival: bindingForSelectedCarnival())
                    } else {
                        AthletesToolbar(carnival: bindingForSelectedCarnival())
                    }
                }
            }

            // Inspector toggle at the far right
            ToolbarItem(placement: .automatic) {
                Spacer()
                Button("Show Inspector", systemImage: "sidebar.right") {
                    showingInspector.toggle()
                }
                .help("Open/Close the sidebar inspector, where actions such as adding notes or viewing file history can be performed.")
            }
        }
    }

    // Helper to get binding to currently selected carnival
    private func bindingForSelectedCarnival() -> Binding<Carnival> {
        guard let selected = carnivalManager.selectedCarnival,
              let index = carnivalManager.carnivals.firstIndex(where: { $0.id == selected.id }) else {
            // This should never fail if used correctly
            return .constant(Carnival(name: "Unknown", date: Date()))
        }
        return $carnivalManager.carnivals[index]
    }
}

// MARK: - Toolbar Controls for Events and Athletes

struct EventsToolbar: View {
    @Binding var carnival: Carnival
    @State private var showingNewEventSheet = false
    @State private var showingScoreEventSheet = false
    @State private var showingEditEventSheet = false
    @State private var showingRanksSheet = false
    @State private var showingDeletionAlert = false
    @State private var selection: Set<Event.ID> = []
    @State private var sortOrder = [KeyPathComparator(\Event.eventName)]

    var body: some View {
        HStack {
            Button("View Ranks", systemImage: "trophy") {
                showingRanksSheet.toggle()
            }
            .disabled(selection.isEmpty)
            .help("View previously generated ranks")

            Button("Score Event", systemImage: "list.bullet.clipboard") {
                showingScoreEventSheet.toggle()
            }
            .disabled(selection.isEmpty)
            .help("Score event.")

            Button("Edit Event", systemImage: "pencil") {
                showingEditEventSheet.toggle()
            }
            .disabled(selection.isEmpty)
            .help("Edit event information.")

            Button("Delete Event", systemImage: "trash") {
                showingDeletionAlert.toggle()
            }
            .disabled(selection.isEmpty)
            .help("Delete event.")

            Divider().frame(height: 28)

            Button("New Event", systemImage: "plus") {
                showingNewEventSheet.toggle()
            }
            .help("Create new event(s).")
        }
        // Sheets and alerts as needed, for the toolbar's actions
        .sheet(isPresented: $showingNewEventSheet) {
            NewEvent(reopenEventSheet: .constant(false), carnival: carnival)
        }
        .alert("Delete Event?", isPresented: $showingDeletionAlert) {
            Button("Delete", role: .destructive) {
                if let eventToDelete = selection.first {
                    carnival.events.removeAll(where: { $0.id == eventToDelete })
                    selection = []
                }
            }
        } message: { Text("This action cannot be undone.") }
        // For the rest, add more sheets as needed or wire up selection with the Table as appropriate.
    }
}

struct AthletesToolbar: View {
    @Binding var carnival: Carnival
    @State private var showingNewAthleteSheet = false
    @State private var showingEditAthleteSheet = false
    @State private var showingExportSheet = false
    @State private var showingDeletionAlert = false
    @State private var selection: Set<Athlete.ID> = []
    @State private var importErrors: [String] = []
    @State private var showAlert = false

    var body: some View {
        HStack {
            Menu("Export Athletes", systemImage: "square.and.arrow.up") {
                Button("Import Athletes (.csv)") {
                    // Implement CSV import as needed
                }
                Button("Export Athletes (.csv)") {
                    showingExportSheet.toggle()
                }
            }
            .help("Export all athletes. (.csv)")
            .frame(height: 28)

            Button("Edit Athlete", systemImage: "pencil") {
                showingEditAthleteSheet.toggle()
            }
            .disabled(selection.isEmpty)
            .help("Edit athlete information.")

            Button("Delete Athlete", systemImage: "trash") {
                showingDeletionAlert.toggle()
            }
            .disabled(selection.isEmpty)
            .help("Delete athlete.")

            Button("New Athlete", systemImage: "plus") {
                showingNewAthleteSheet.toggle()
            }
            .help("Create new athlete")
        }
        // Sheets and alerts as needed for the toolbar's actions. Wire up as per EventsToolbar.
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var showingInspector = false

        var body: some View {
            ContentView(showingInspector: $showingInspector)
                .environmentObject(CarnivalManager.shared)
                .frame(width: 1000)
        }
    }
    return PreviewWrapper()
}


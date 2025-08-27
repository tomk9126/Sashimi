//
//  InspectorView.swift
//  Sashimi
//
//  Created by Tom Keir on 27/8/2025.
//

import SwiftUI

struct InspectorView: View {
    
    enum inspectors {
        case history
        case notes
    }
    
    @State private var selectedInspector = inspectors.history
    var body: some View {
        VStack {
            Picker("Inspector", selection: $selectedInspector) {
                Text("File History").tag(inspectors.history)
                Text("Notes").tag(inspectors.notes)
            }.pickerStyle(.segmented)
            .labelsHidden()
            
            Spacer()
        }
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


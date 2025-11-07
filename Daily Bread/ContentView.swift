//
//  ContentView.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct ContentView: View {
    var body: some View {
        TabNavigationView()
    }
}

// Extension for ManagedSettingsStore name to match monitor extension
extension ManagedSettingsStore.Name {
    static let main = ManagedSettingsStore.Name("main")
}

#Preview {
    ContentView()
}

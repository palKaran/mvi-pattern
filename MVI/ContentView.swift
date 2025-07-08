//
//  ContentView.swift
//  MVI
//
//  Created by Karan Pal on 08/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
// User does something → Intent → Model → View → User sees it
// No shortcuts, no backdoors, predictable

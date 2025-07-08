//
//  CounterView.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import SwiftUI

struct CounterView: View {
    @StateObject private var store = CounterStore()
    
    var body: some View {
        VStack(spacing: 20) {
            // Display current count
            Text("\(store.state.count)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Show last operation if available
            if let lastOperation = store.state.lastOperation {
                Text(lastOperation)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        store.send(.clearLastOperation)
                    }
            }
            
            // Action buttons
            HStack(spacing: 15) {
                Button("-") {
                    store.send(.decrement)
                }
                .buttonStyle(.bordered)
                
                Button("+") {
                    store.send(.increment)
                }
                .buttonStyle(.bordered)
                
                Button("Reset") {
                    store.send(.reset)
                }
                .buttonStyle(.bordered)
            }
            
            // Async increment button with loading state
            Button(action: {
                store.send(.asyncIncrement)
            }) {
                HStack {
                    if store.state.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    Text("Async +1")
                }
            }
            .disabled(store.state.isLoading)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    CounterView()
}

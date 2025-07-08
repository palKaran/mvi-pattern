//
//  CounterStore.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import Foundation

@MainActor
final class CounterStore: MVIStore {
    @Published private(set) var state = CounterState()
    
    func send(_ intent: CounterIntent) {
        switch intent {
        case .increment:
            handleIncrement()
            
        case .decrement:
            handleDecrement()
            
        case .reset:
            handleReset()
            
        case .asyncIncrement:
            handleAsyncIncrement()
            
        case .clearLastOperation:
            handleClearLastOperation()
        }
    }
    
    // MARK: - Intent Handlers
    
    private func handleIncrement() {
        state = state.copy(
            count: state.count + 1,
            lastOperation: "Incremented to \(state.count + 1)"
        )
    }
    
    private func handleDecrement() {
        state = state.copy(
            count: state.count - 1,
            lastOperation: "Decremented to \(state.count - 1)"
        )
    }
    
    private func handleReset() {
        state = state.copy(
            count: 0,
            lastOperation: "Reset to 0"
        )
    }
    
    private func handleAsyncIncrement() {
        // First, show loading state
        state = state.copy(
            isLoading: true,
            lastOperation: "Processing async increment..."
        )
        
        // Simulate async operation
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            state = state.copy(
                count: state.count + 1,
                isLoading: false,
                lastOperation: "Async incremented to \(state.count + 1)"
            )
        }
    }
    
    private func handleClearLastOperation() {
        state = state.copy(lastOperation: nil)
    }
}

//
//  CounterState.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import Foundation

struct CounterState {
    let count: Int
    let isLoading: Bool
    let lastOperation: String?
    
    init(count: Int = 0, isLoading: Bool = false, lastOperation: String? = nil) {
        self.count = count
        self.isLoading = isLoading
        self.lastOperation = lastOperation
    }
}

// Helper for creating new state instances
extension CounterState {
    func copy(
        count: Int? = nil,
        isLoading: Bool? = nil,
        lastOperation: String? = nil
    ) -> CounterState {
        CounterState(
            count: count ?? self.count,
            isLoading: isLoading ?? self.isLoading,
            lastOperation: lastOperation ?? self.lastOperation
        )
    }
}

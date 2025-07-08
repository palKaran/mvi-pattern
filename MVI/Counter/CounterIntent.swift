//
//  CounterIntent.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//

enum CounterIntent {
    case increment
    case decrement
    case reset
    case asyncIncrement // For demonstrating async operations
    case clearLastOperation
}

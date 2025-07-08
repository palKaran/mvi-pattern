//
//  MVIStore.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import Foundation

@MainActor
protocol MVIStore: ObservableObject {
    associatedtype State
    associatedtype Intent
    
    var state: State { get }
    func send(_ intent: Intent)
}

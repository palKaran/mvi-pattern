//
//  Todo.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import Foundation

struct Todo: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    let createdAt: Date
    
    init(title: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
    
    // Custom init for decoding
    init(id: UUID, title: String, isCompleted: Bool, createdAt: Date) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

enum TodoFilter: CaseIterable {
    case all, active, completed
    
    var title: String {
        switch self {
        case .all: return "All"
        case .active: return "Active"
        case .completed: return "Completed"
        }
    }
}

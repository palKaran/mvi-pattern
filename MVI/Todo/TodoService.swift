//
//  TodoService.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import SwiftUI

@MainActor
class TodoService {
    static let shared = TodoService()
    private init() {}
    
    @AppStorage("todos_data") private var todosData: Data = Data()
    
    private var todos: [Todo] {
        get {
            guard !todosData.isEmpty else { 
                return [] // Start with empty list
            }
            
            do {
                return try JSONDecoder().decode([Todo].self, from: todosData)
            } catch {
                print("Failed to decode todos: \(error)")
                return []
            }
        }
        set {
            do {
                todosData = try JSONEncoder().encode(newValue)
            } catch {
                print("Failed to encode todos: \(error)")
            }
        }
    }
    
    func loadTodos() async -> [Todo] {
        // Small delay to show loading state in UI
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        return todos
    }
    
    func addTodo(_ todo: Todo) async -> Todo {
        var currentTodos = todos
        currentTodos.append(todo)
        todos = currentTodos
        return todo
    }
    
    func updateTodo(_ todo: Todo) async -> Todo {
        var currentTodos = todos
        if let index = currentTodos.firstIndex(where: { $0.id == todo.id }) {
            currentTodos[index] = todo
        }
        todos = currentTodos
        return todo
    }
    
    func deleteTodo(id: UUID) async {
        var currentTodos = todos
        currentTodos.removeAll { $0.id == id }
        todos = currentTodos
    }
    
    func clearCompleted() async {
        var currentTodos = todos
        currentTodos.removeAll { $0.isCompleted }
        todos = currentTodos
    }
}

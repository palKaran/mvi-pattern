//
//  TodoState.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import Foundation

struct TodoState {
    // Core data
    var todos: [Todo] = []
    var newTodoText: String = ""
    var currentFilter: TodoFilter = .all
    
    // UI states
    var isLoading: Bool = false
    var isAddingTodo: Bool = false
    
    // Editing state
    var editingTodoId: UUID? = nil
    var editingText: String = ""
    
    // Computed properties for derived state
    var filteredTodos: [Todo] {
        switch currentFilter {
        case .all:
            return todos
        case .active:
            return todos.filter { !$0.isCompleted }
        case .completed:
            return todos.filter { $0.isCompleted }
        }
    }
    
    var canAddTodo: Bool {
        !newTodoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isAddingTodo
    }
    
    var activeTodoCount: Int {
        todos.filter { !$0.isCompleted }.count
    }
    
    var completedTodoCount: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    var isEmpty: Bool {
        todos.isEmpty
    }
}

// Helper for immutable updates
extension TodoState {
    func copy(
        todos: [Todo]? = nil,
        newTodoText: String? = nil,
        currentFilter: TodoFilter? = nil,
        isLoading: Bool? = nil,
        isAddingTodo: Bool? = nil,
        editingTodoId: UUID? = nil,
        editingText: String? = nil
    ) -> TodoState {
        var newState = self
        if let todos = todos { newState.todos = todos }
        if let newTodoText = newTodoText { newState.newTodoText = newTodoText }
        if let currentFilter = currentFilter { newState.currentFilter = currentFilter }
        if let isLoading = isLoading { newState.isLoading = isLoading }
        if let isAddingTodo = isAddingTodo { newState.isAddingTodo = isAddingTodo }
        if let editingTodoId = editingTodoId { newState.editingTodoId = editingTodoId }
        if let editingText = editingText { newState.editingText = editingText }
        return newState
    }
}

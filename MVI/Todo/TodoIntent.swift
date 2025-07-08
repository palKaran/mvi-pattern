//
//  TodoIntent.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import Foundation

enum TodoIntent {
    // Loading and data management
    case loadTodos
    case refreshTodos
    
    // Adding todos
    case updateNewTodoText(String)
    case addTodo
    
    // Todo operations
    case toggleTodo(UUID)
    case deleteTodo(UUID)
    case clearCompleted
    
    // Editing
    case startEditing(UUID)
    case updateEditingText(String)
    case saveEdit
    case cancelEdit
    
    // Filtering
    case changeFilter(TodoFilter)
}

//
//  TodoStore.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import SwiftUI

@MainActor
final class TodoStore: MVIStore {
    @Published private(set) var state = TodoState()
    private let todoService = TodoService.shared

    // MARK: - Binding Properties
    var newTodoTextBinding: Binding<String> {
        Binding(
            get: { self.state.newTodoText },
            set: { self.send(.updateNewTodoText($0)) }
        )
    }

    var filterBinding: Binding<TodoFilter> {
        Binding(
            get: { self.state.currentFilter },
            set: { self.send(.changeFilter($0)) }
        )
    }

    var editingTextBinding: Binding<String> {
        Binding(
            get: { self.state.editingText },
            set: { self.send(.updateEditingText($0)) }
        )
    }

    func send(_ intent: TodoIntent) {
        switch intent {
        case .loadTodos:
            handleLoadTodos()
        case .refreshTodos:
            handleRefreshTodos()
        case .updateNewTodoText(let text):
            handleUpdateNewTodoText(text)
        case .addTodo:
            handleAddTodo()
        case .toggleTodo(let id):
            handleToggleTodo(id)
        case .deleteTodo(let id):
            handleDeleteTodo(id)
        case .clearCompleted:
            handleClearCompleted()
        case .startEditing(let id):
            handleStartEditing(id)
        case .updateEditingText(let text):
            handleUpdateEditingText(text)
        case .saveEdit:
            handleSaveEdit()
        case .cancelEdit:
            handleCancelEdit()
        case .changeFilter(let filter):
            handleChangeFilter(filter)
        }
    }
    
    // MARK: - Loading and Data Management
    
    private func handleLoadTodos() {
        guard !state.isLoading else { return }
        
        state = state.copy(isLoading: true)
        
        Task { @MainActor in
            let todos = await todoService.loadTodos()
            state = state.copy(todos: todos, isLoading: false)
        }
    }
    
    private func handleRefreshTodos() {
        Task { @MainActor in
            let todos = await todoService.loadTodos()
            state = state.copy(todos: todos)
        }
    }
    
    // MARK: - Adding Todos
    
    private func handleUpdateNewTodoText(_ text: String) {
        state = state.copy(newTodoText: text)
    }
    
    private func handleAddTodo() {
        guard state.canAddTodo else { return }
        
        let todoText = state.newTodoText.trimmingCharacters(in: .whitespacesAndNewlines)
        let newTodo = Todo(title: todoText)
        
        state = state.copy(isAddingTodo: true)
        
        Task { @MainActor in
            let addedTodo = await todoService.addTodo(newTodo)
            var updatedTodos = state.todos
            updatedTodos.append(addedTodo)
            
            state = state.copy(
                todos: updatedTodos,
                newTodoText: "",
                isAddingTodo: false
            )
        }
    }
    
    // MARK: - Todo Operations
    
    private func handleToggleTodo(_ id: UUID) {
        guard let todoIndex = state.todos.firstIndex(where: { $0.id == id }) else { return }
        
        var updatedTodo = state.todos[todoIndex]
        updatedTodo.isCompleted.toggle()
        
        var updatedTodos = state.todos
        updatedTodos[todoIndex] = updatedTodo
        
        // Update UI immediately
        state = state.copy(todos: updatedTodos)
        
        Task { @MainActor in
            _ = await todoService.updateTodo(updatedTodo)
        }
    }
    
    private func handleDeleteTodo(_ id: UUID) {
        let updatedTodos = state.todos.filter { $0.id != id }
        
        // Update UI immediately
        state = state.copy(todos: updatedTodos)
        
        Task { @MainActor in
            await todoService.deleteTodo(id: id)
        }
    }
    
    private func handleClearCompleted() {
        Task { @MainActor in
            await todoService.clearCompleted()
            let todos = await todoService.loadTodos()
            state = state.copy(todos: todos)
        }
    }
    
    // MARK: - Editing
    
    private func handleStartEditing(_ id: UUID) {
        guard let todo = state.todos.first(where: { $0.id == id }) else { return }
        state = state.copy(editingTodoId: id, editingText: todo.title)
    }
    
    private func handleUpdateEditingText(_ text: String) {
        state = state.copy(editingText: text)
    }
    
    private func handleSaveEdit() {
        guard let editingId = state.editingTodoId,
              let todoIndex = state.todos.firstIndex(where: { $0.id == editingId }) else { return }
        
        var updatedTodo = state.todos[todoIndex]
        updatedTodo.title = state.editingText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var updatedTodos = state.todos
        updatedTodos[todoIndex] = updatedTodo
        
        state = state.copy(
            todos: updatedTodos,
            editingTodoId: nil,
            editingText: ""
        )
        
        Task { @MainActor in
            _ = await todoService.updateTodo(updatedTodo)
        }
    }
    
    private func handleCancelEdit() {
        state = state.copy(editingTodoId: nil, editingText: "")
    }
    
    // MARK: - Filtering
    
    private func handleChangeFilter(_ filter: TodoFilter) {
        state = state.copy(currentFilter: filter)
    }
}

//
//  TodoListView.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import SwiftUI
struct TodoListView: View {
    @StateObject private var store = TodoStore()

    var body: some View {
        NavigationView {
            VStack {
                if store.state.isLoading {
                    loadingView
                } else if store.state.isEmpty {
                    emptyStateView
                } else {
                    todoContent
                }
            }
            .navigationTitle("My Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if store.state.completedTodoCount > 0 {
                        Button("Clear Completed") {
                            store.send(.clearCompleted)
                        }
                    }
                }
            }
            .onAppear {
                store.send(.loadTodos)
            }
        }
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading todos...")
                .foregroundColor(.secondary)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.largeTitle)
                .foregroundColor(.secondary)

            Text("No todos yet")
                .font(.headline)

            Text("Add your first todo below to get started!")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            addTodoSection
        }
        .padding()
    }

    private var todoContent: some View {
        VStack {
            filterSection
            todoList
            addTodoSection
            statsSection
        }
    }

    private var filterSection: some View {
        Picker("Filter", selection: store.filterBinding) {
            ForEach(TodoFilter.allCases, id: \.self) { filter in
                Text(filter.title).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    private var todoList: some View {
        List {
            ForEach(store.state.filteredTodos) { todo in
                TodoRowView(
                    todo: todo,
                    isEditing: store.state.editingTodoId == todo.id,
                    editingTextBinding: store.editingTextBinding,
                    onToggle: { store.send(.toggleTodo(todo.id)) },
                    onDelete: { store.send(.deleteTodo(todo.id)) },
                    onStartEdit: { store.send(.startEditing(todo.id)) },
                    onSaveEdit: { store.send(.saveEdit) },
                    onCancelEdit: { store.send(.cancelEdit) }
                )
            }
        }
        .refreshable {
            store.send(.refreshTodos)
        }
    }

    private var addTodoSection: some View {
        HStack {
            TextField("What needs to be done?", text: store.newTodoTextBinding)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    if store.state.canAddTodo {
                        store.send(.addTodo)
                    }
                }

            Button(action: { store.send(.addTodo) }) {
                if store.state.isAddingTodo {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            .disabled(!store.state.canAddTodo)
        }
        .padding()
    }

    private var statsSection: some View {
        HStack {
            Text("\(store.state.activeTodoCount) active")
            Spacer()
            Text("\(store.state.completedTodoCount) completed")
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
}

#Preview {
    TodoListView()
}


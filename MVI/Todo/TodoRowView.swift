//
//  TodoRowView.swift
//  MVI Article
//
//  Created by Karan Pal on 08/07/25.
//
import SwiftUI

struct TodoRowView: View {
    let todo: Todo
    let isEditing: Bool
    let editingTextBinding: Binding<String>

    let onToggle: () -> Void
    let onDelete: () -> Void
    let onStartEdit: () -> Void
    let onSaveEdit: () -> Void
    let onCancelEdit: () -> Void

    var body: some View {
        HStack {
            // Completion toggle
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)

            // Todo content
            if isEditing {
                editingView
            } else {
                displayView
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete", role: .destructive, action: onDelete)
        }
        .swipeActions(edge: .leading) {
            Button("Edit", action: onStartEdit)
                .tint(.blue)
        }
    }

    private var displayView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)

                Text(todo.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onStartEdit()
        }
    }

    private var editingView: some View {
        HStack {
            TextField("Todo title", text: editingTextBinding)
                .textFieldStyle(.roundedBorder)
                .onSubmit(onSaveEdit)

            Button("Save", action: onSaveEdit)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)

            Button("Cancel", action: onCancelEdit)
                .buttonStyle(.bordered)
                .controlSize(.small)
        }
    }
}

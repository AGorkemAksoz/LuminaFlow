//
//  DashboardTaskCellView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 3.04.2026.
//

import SwiftUI

struct DashboardTaskCellView: View {
    let selectedTask: TaskItem
    
    let onToggleTask: (TaskItem) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            toggleButton
            VStack(alignment: .leading, spacing: 8) {
                taskName
                
                HStack {
                    if let reminder = selectedTask.reminder {
                        HStack {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text(reminder.formatted(date: .omitted, time: .shortened))
                                .foregroundStyle(.primary.opacity(0.75))
                        }
                        .luminaStyle(.timeMetadata)
                    }
                    
                    if let tag = selectedTask.tag {
                        // Circle Divider must be shown if there is another cell element to its left.
                        if selectedTask.reminder != nil {
                            circleDivider
                        }
                        CellTaskTagPill(tag: tag)
                    }
                    
                    if selectedTask.priority == .high || selectedTask.priority == .urgent {
                        // Circle Divider must be shown if there is another cell element to its left.
                        if selectedTask.reminder != nil || selectedTask.tag != nil {
                            circleDivider
                        }
                        priorityTag
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

// MARK: - UI Components
extension DashboardTaskCellView {
    private var toggleButton: some View {
        Button {
            onToggleTask(selectedTask)
        } label: {
            if selectedTask.isFinished {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .foregroundStyle(.white)
                    .background(Color.luminaSeedBlue)
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
            } else {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.gray)
            }
        }
        .buttonStyle(.plain)

    }
    
    private var taskName: some View {
        Text(selectedTask.title)
            .luminaStyle(.taskTitle)
            .strikethrough(selectedTask.isFinished)
    }
    
    private var circleDivider: some View {
        Image(systemName: "circle")
            .resizable()
            .frame(width: 8, height: 8)
    }
    
    private var priorityTag: some View {
        Image(systemName: selectedTask.priority.iconName)
            .resizable()
            .frame(width: 16, height: 16)
            .padding(8)
            .background(selectedTask.priority == .urgent ? Color.red.opacity(0.15) : Color.personalTagBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

//#Preview {
//    DashboardTaskCellView()
//}

struct CellTaskTagPill: View {
    let tag: TaskTag
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: tag.icon)
                .font(.system(size: 10, weight: .semibold))
            Text(tag.title)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
        }
        .foregroundColor(.primary.opacity(0.75))
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

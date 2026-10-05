//
//  TaskDetailView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 8.09.2026.
//

import SwiftUI

// MARK: - Model

struct TaskSubtask: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

// MARK: - View

struct TaskDetailView: View {

    @Environment(\.dismiss) private var dismiss

    let title: String
    let dueLabel: String?
    let tagLabel: String?
    let notes: String?

    @State private var subtasks: [TaskSubtask]
    @State private var isConfirmingDelete: Bool = false

    var onComplete: (() -> Void)?
    var onMore: (() -> Void)?
    var onDelete: (() -> Void)?

    init(
        title: String,
        dueLabel: String? = "Due Today",
        tagLabel: String? = "Work",
        notes: String? = nil,
        subtasks: [TaskSubtask] = [],
        onComplete: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil,
        onMore: (() -> Void)? = nil
    ) {
        self.title = title
        self.dueLabel = dueLabel
        self.tagLabel = tagLabel
        self.notes = notes
        _subtasks = State(initialValue: subtasks)
        self.onComplete = onComplete
        self.onDelete = onDelete
        self.onMore = onMore
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.luminaBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: LuminaSpacing.sectionGap) {
                    header
                    headerGroup
                    notesSection
                    subtasksSection
                    Color.clear.frame(height: 72) // CTA butonun altta kapatmaması için boşluk
                }
                .padding(.horizontal, LuminaSpacing.screenHorizontalPadding)
                .padding(.top, 8)
            }

            completeButton
                .padding(.horizontal, LuminaSpacing.screenHorizontalPadding)
                .padding(.bottom, 16)
        }
        .confirmationDialog("Delete this task?", isPresented: $isConfirmingDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { onDelete?() }
            Button("Cancel", role: .cancel) { }
        }
        .navigationBarBackButtonHidden()
    }

    // MARK: Header (back / more)

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
            }

            Spacer()

            Button {
                isConfirmingDelete = true
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
            }
        }
    }

    // MARK: Title + Chips

    private var headerGroup: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .luminaStyle(.detailTitle)

            chipsRow
        }
    }

    private var chipsRow: some View {
        HStack(spacing: 10) {
            if let dueLabel {
                chip(icon: "calendar", text: dueLabel)
            }
            if let tagLabel {
                chip(icon: "briefcase.fill", text: tagLabel)
            }
        }
    }

    private func chip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .luminaStyle(.detailChipLabel)
        }
        .foregroundStyle(Color.chipForeground)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(Color.chipBackground)
        )
    }

    // MARK: Section Label

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .luminaStyle(.detailSectionLabel)
    }

    // MARK: Notes

    @ViewBuilder
    private var notesSection: some View {
        if let notes {
            VStack(alignment: .leading, spacing: 12) {
                sectionLabel("Notes")

                Text(notes)
                    .luminaStyle(.detailNotes)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(LuminaSpacing.notesCardPadding)
                    .background(cardBackground(cornerRadius: LuminaSpacing.notesCornerRadius))
            }
        }
    }

    // MARK: Sub-tasks

    private var subtasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Sub-tasks")

            VStack(spacing: LuminaSpacing.subtaskGap) {
                ForEach($subtasks) { $subtask in
                    subtaskRow($subtask)
                }
            }
        }
    }

    private func subtaskRow(_ subtask: Binding<TaskSubtask>) -> some View {
        Button {
            withAnimation(.snappy) {
                subtask.wrappedValue.isCompleted.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                checkbox(isChecked: subtask.wrappedValue.isCompleted)

                Text(subtask.wrappedValue.title)
                    .luminaStyle(.detailSubtask)
                    .strikethrough(subtask.wrappedValue.isCompleted, color: Color.textMuted)
                    .foregroundStyle(
                        subtask.wrappedValue.isCompleted ? Color.textMuted : Color.textPrimary
                    )

                Spacer()
            }
            .padding(LuminaSpacing.subtaskCardPadding)
            .background(cardBackground(cornerRadius: LuminaSpacing.subtaskCornerRadius))
        }
        .buttonStyle(.plain)
    }

    private func checkbox(isChecked: Bool) -> some View {
        ZStack {
            Circle()
                .fill(isChecked ? Color.checkboxFillChecked : Color.surface)
            Circle()
                .strokeBorder(isChecked ? Color.clear : Color.checkboxBorder, lineWidth: 1.5)
            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 24, height: 24)
    }

    // MARK: Shared card background (border + double shadow)

    private func cardBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.surface)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.cardBorder, lineWidth: 1)
            )
            .shadow(color: Color.cardShadowStrong, radius: 12, x: 0, y: 4)
            .shadow(color: Color.cardShadowSoft, radius: 3, x: 0, y: 1)
    }

    // MARK: Complete Button

    private var completeButton: some View {
        Button {
            onComplete?()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                Text("Complete Task")
                    .luminaStyle(.detailCompleteButton)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.ctaGradientStart, Color.ctaGradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color.ctaShadow, radius: 12, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    TaskDetailView(
        title: "Draft Quarterly Report",
        dueLabel: "Due Today",
        tagLabel: "Work",
        notes: "Make sure to include the Q3 financial projections and the marketing summary. Keep the tone professional but optimistic.",
        subtasks: [
            TaskSubtask(title: "Gather financial data"),
            TaskSubtask(title: "Review with Sarah"),
            TaskSubtask(title: "Export PDF", isCompleted: true)
        ]
    )
}

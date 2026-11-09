//
//  AddSubtasksSheet.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 14.10.2026.
//

import SwiftUI

// MARK: - Theme
/// Tüm renkler, ölçüler ve köşe yarıçapları burada.
/// Kendi tasarım sisteminize geçerken sadece bu bloğu değiştirmeniz yeterli.
enum Theme {
    // Renkler
    static let sheetBackground   = Color(hex: "#FFFFFF")
    static let canvasBackground  = Color(hex: "#F3F2F7")   // sheet dışı arka plan (preview için)
    static let primary           = Color(hex: "#3426E4")   // ana buton, + butonu, tarih metni
    static let primaryText       = Color(hex: "#FFFFFF")   // primary üzerindeki yazı
    static let primarySoft       = Color(hex: "#E9E7FF")   // "Active" rozeti zemini
    static let primarySoftText   = Color(hex: "#2A1FD0")   // "Active" rozeti yazısı

    static let textPrimary       = Color(hex: "#1C1B2E")
    static let textSecondary     = Color(hex: "#5B5873")
    static let textMuted         = Color(hex: "#8D89A8")

    static let surface           = Color(hex: "#F8F7FF")   // input kartı & satır zemini
    static let surfaceBorder     = Color(hex: "#E3E0F4")
    static let fieldBackground   = Color(hex: "#FFFFFF")
    static let chipBackground    = Color(hex: "#EDEBFA")
    static let chipSelected      = Color(hex: "#DAD6FF")
    static let chipIcon          = Color(hex: "#5A53B5")

    static let secondaryButton   = Color(hex: "#EDEBFA")
    static let secondaryButtonText = Color(hex: "#4A4763")

    static let checkboxStroke    = Color(hex: "#C9C5DD")
    static let iconMuted         = Color(hex: "#8A869E")
    static let dashedBorder      = Color(hex: "#CFCBE6")
    static let dashedText        = Color(hex: "#7D78B0")
    static let grabber           = Color(hex: "#D9D7E3")
    static let closeButton       = Color(hex: "#EDEBFA")

    // Ölçüler
    static let sheetRadius: CGFloat = 32
    static let cardRadius: CGFloat  = 20
    static let rowRadius: CGFloat   = 18
    static let hPadding: CGFloat    = 24
}

// MARK: - Main Sheet
struct AddSubtasksSheet: View {
    
    var status: String = "Active"

    @FocusState private var inputFocused: Bool
    
    @ObservedObject var viewModel: CreateTaskViewModel
    @Environment(\.dismiss) private var dismiss

    init(status: String = "Active",
         viewModel: CreateTaskViewModel) {
        self.status = status
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            grabber
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    inputCard
                    subtasksSection
                }
                .padding(.horizontal, Theme.hPadding)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomBar }
        .background(Theme.sheetBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.sheetRadius, style: .continuous))
    }

    // MARK: Grabber
    private var grabber: some View {
        Capsule()
            .fill(Theme.grabber)
            .frame(width: 48, height: 5)
            .padding(.top, 10)
            .padding(.bottom, 14)
    }

    // MARK: Header
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Text("Add Subtasks")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(status)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.primarySoftText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Theme.primarySoft, in: Capsule())
                }
                Text(viewModel.title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Button(action: dismiss.callAsFunction) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                    .frame(width: 56, height: 56)
                    .background(Theme.closeButton, in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Input card
    private var inputCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 8) {
                TextField("Enter subtask name...", text: $viewModel.draftTitle)
                    .font(.system(size: 19))
                    .foregroundStyle(Theme.textPrimary)
                    .focused($inputFocused)
                    .submitLabel(.done)
                    .onSubmit { viewModel.addDraft() }
                    .padding(.leading, 12)

                Button { viewModel.addDraft() } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Theme.primaryText)
                        .frame(width: 50, height: 50)
                        .background(Theme.primary, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .opacity(viewModel.canAdd ? 1 : 0.5)
                }
                .buttonStyle(.plain)
                .disabled(!viewModel.canAdd)
            }
            .padding(8)
            .background(Theme.fieldBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Theme.primary.opacity(0.06), radius: 8, y: 2)
        }
        .padding(16)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous)
                .strokeBorder(Theme.surfaceBorder, lineWidth: 1)
        )
    }

    // MARK: Subtasks list
    private var subtasksSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Subtasks")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                Text("\(viewModel.subtaskItems.count) items")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.textMuted)
            }

            VStack(spacing: 12) {
                ForEach(viewModel.subtaskItems) { item in
                    SubtaskRow(item: item,
                               onToggle: { viewModel.toggle(item) },
                               onDelete: { viewModel.delete(item) })
                        .dropDestination(for: String.self) { dropped, _ in
                            guard let first = dropped.first else { return false }
                            viewModel.move(idString: first, onto: item)
                            return true
                        }
                }

                addAnotherButton
            }
        }
    }

    private var addAnotherButton: some View {
        Button { inputFocused = true } label: {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 22))
                Text("Add another item")
                    .font(.system(size: 18, weight: .medium))
            }
            .foregroundStyle(Theme.dashedText)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.rowRadius, style: .continuous)
                    .strokeBorder(Theme.dashedBorder,
                                  style: StrokeStyle(lineWidth: 2, dash: [7, 6]))
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: Bottom bar
    private var bottomBar: some View {
        HStack(spacing: 14) {
            Button(action: dismiss.callAsFunction) {
                Text("Cancel")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.secondaryButtonText)
                    .frame(width: 172, height: 80)
                    .background(Theme.secondaryButton, in: Capsule())
            }
            .buttonStyle(.plain)

            Button { dismiss.callAsFunction() } label: {
                HStack(spacing: 12) {
                    Text("Apply Subtasks")
                        .font(.system(size: 20, weight: .semibold))
                    Text("\(viewModel.subtaskItems.count)")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.22), in: Capsule())
                }
                .foregroundStyle(Theme.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Theme.primary, in: Capsule())
                .shadow(color: Theme.primary.opacity(0.35), radius: 16, y: 8)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.hPadding)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(
            LinearGradient(colors: [Theme.sheetBackground.opacity(0), Theme.sheetBackground],
                           startPoint: .top, endPoint: .center)
        )
    }
}

// MARK: - Row
struct SubtaskRow: View {
    let item: SubtaskItem
    var onToggle: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .strokeBorder(item.isCompleted ? Theme.primary : Theme.checkboxStroke, lineWidth: 2.5)
                        .frame(width: 32, height: 32)
                    if item.isCompleted {
                        Circle().fill(Theme.primary).frame(width: 32, height: 32)
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Theme.primaryText)
                    }
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .strikethrough(item.isCompleted)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer(minLength: 4)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 20))
                    .foregroundStyle(Theme.iconMuted)
            }
            .buttonStyle(.plain)

            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Theme.iconMuted)
                .padding(.leading, 6)
                .draggable(item.id.uuidString) {
                    Text(item.title)
                        .padding(12)
                        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
                }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.rowRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.rowRadius, style: .continuous)
                .strokeBorder(Theme.surfaceBorder, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    let container = DependencyContainer(persistenceController: .preview)

    ZStack {
        Theme.canvasBackground.ignoresSafeArea()
        AddSubtasksSheet(viewModel: container.makeCreateTaskViewModel())
        .padding(.horizontal, 8)
    }
}

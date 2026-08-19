//
//  TaskTagPickerView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 17.08.2026.
//

import SwiftUI

// MARK: - Flow Layout (etiketleri sarmalayan bir "tag cloud" düzeni)

struct FlowLayout: Layout {
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var rowWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if rowWidth + size.width > width, rowWidth > 0 {
                totalHeight += rowHeight + spacing
                rowWidth = 0
                rowHeight = 0
            }
            rowWidth += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        totalHeight += rowHeight
        return CGSize(width: width, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - Tag Pill

struct TagPill: View {
    let tag: TaskTag
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tag.icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(tag.title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(isSelected ? Color.saveTaskBackground : .primary.opacity(0.75))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? Color.saveTaskBackground.opacity(0.12) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? Color.saveTaskBackground : .clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

struct CreateNewPill: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "plus")
                .font(.system(size: 13, weight: .semibold))
            Text("Create New")
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                .foregroundColor(Color(.systemGray3))
        )
    }
}

// MARK: - Tag Picker Sheet

struct TaskTagPickerView: View {
    @State private var searchText = ""
    @Binding var selectedTag: TaskTag?
    @Environment(\.dismiss) private var dismiss
 
    var filteredTags: [TaskTag] {
        guard !searchText.isEmpty else { return TaskTag.allCases }
        return TaskTag.allCases.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
 
    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 18)
 
            // Header
            HStack {
                Text("Select Category")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color(.secondarySystemBackground)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
 
            // Search bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search categories...", text: $searchText)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
 
            // Tag pills
            FlowLayout(spacing: 10) {
                ForEach(filteredTags) { tag in
                    TagPill(
                        tag: tag,
                        isSelected: selectedTag == tag,
                        action: { select(tag) }
                    )
                }
                // TODO: Wire the create new pill
//                CreateNewPill()
            }
            .padding(.horizontal, 20)
 
            Spacer(minLength: 20)
 
            // Confirm button
            Button(action: { dismiss() }) {
                HStack(spacing: 8) {
                    Text("Confirm Selection")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule().fill(Color.saveTaskBackground)
                )
            }
            .animation(.easeInOut(duration: 0.15), value: selectedTag)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
    }
 
    private func select(_ tag: TaskTag) {
        // Aynı etikete tekrar dokunulursa seçim kaldırılır, farklı bir etikete
        // dokunulursa önceki seçimin yerini alır.
        selectedTag = (selectedTag == tag) ? nil : tag
    }
}

#Preview {
    TaskTagPickerView(selectedTag: .constant(.education))
}

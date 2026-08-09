//
//  ReminderPickSheet.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 9.08.2026.
//

import SwiftUI

struct ReminderPickSheet: View {
    
    @Binding var selectedDate: Date?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var hour: Int = 9
    @State private var minute: Int = 30
    @State private var isAM: Bool = true

    let calendar: Calendar
    let baseDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                timeCard
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            saveButton
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        }
        .onAppear {
            syncPickers(from: selectedDate)
        }
    }
}

extension ReminderPickSheet {
    private var timeCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Time")
                .font(.headline)
            
            HStack(spacing: 24) {
                Spacer()
                timeStepper(value: $hour, range: 1...12)
                Text(":")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color.saveTaskBackground)
                timeStepper(value: $minute, range: 0...59, pad: true)
                Spacer()
                amPmToggle
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
 
    private func timeStepper(value: Binding<Int>, range: ClosedRange<Int>, pad: Bool = false) -> some View {
        VStack(spacing: 8) {
            Button {
                increment(value, in: range)
            } label: {
                Image(systemName: "chevron.up")
                    .foregroundStyle(.secondary)
            }
 
            Text(pad ? String(format: "%02d", value.wrappedValue) : "\(value.wrappedValue)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.saveTaskBackground)
                .frame(minWidth: 48)
                .contentTransition(.numericText())
 
            Button {
                decrement(value, in: range)
            } label: {
                Image(systemName: "chevron.down")
                    .foregroundStyle(.secondary)
            }
        }
        .animation(.snappy, value: value.wrappedValue)
    }
 
    private func increment(_ value: Binding<Int>, in range: ClosedRange<Int>) {
        value.wrappedValue = value.wrappedValue == range.upperBound ? range.lowerBound : value.wrappedValue + 1
    }
 
    private func decrement(_ value: Binding<Int>, in range: ClosedRange<Int>) {
        value.wrappedValue = value.wrappedValue == range.lowerBound ? range.upperBound : value.wrappedValue - 1
    }
 
    private var amPmToggle: some View {
        VStack(spacing: 6) {
            amPmButton(title: "AM", isSelected: isAM) { isAM = true }
            amPmButton(title: "PM", isSelected: !isAM) { isAM = false }
        }
    }
 
    private func amPmButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .frame(width: 52, height: 32)
                .background(isSelected ? Color.saveTaskBackground : Color.clear)
                .foregroundStyle(isSelected ? .white : .secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
    // MARK: - Save Button
 
    private var saveButton: some View {
        Button {
            if let formattedDate = formatDate(selectedDate ?? Date()) {
                selectedDate = formattedDate
            }
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark")
                    .font(.subheadline.weight(.bold))
                Text("Save Reminder")
                    .font(.body.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.saveTaskBackground)
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
    }
}

extension ReminderPickSheet {
    private func formatDate(_ date: Date) -> Date? {
        var hour24 = hour % 12
        if !isAM { hour24 += 12 }
        
        var components = calendar.dateComponents([.year, .month, .day], from: baseDate)
        components.hour = hour24
        components.minute = minute
        
        return calendar.date(from: components)
    }
    
    private func syncPickers(from date: Date?) {
        guard let date else { return } // nil → 9:30 default kalsın
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        let hour24 = comps.hour ?? 9
        minute = comps.minute ?? 0
        isAM = hour24 < 12
        let hour12 = hour24 % 12
        hour = hour12 == 0 ? 12 : hour12   // 0 → 12 AM/PM
    }

}

#Preview {
    var calendar: Calendar = .autoupdatingCurrent
    
    ReminderPickSheet(selectedDate: .constant(Date()),
                      calendar: calendar,
                      baseDate: Date())
}

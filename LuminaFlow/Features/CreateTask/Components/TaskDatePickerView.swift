//
//  TaskDatePickerView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 10.08.2026.
//

import SwiftUI

struct TaskDatePickerView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let calendar: Calendar
    let initialDate: Date?
    let onConfirm: (Date?) -> Void
    
    @State private var selectedDate: Date?
    @State private var displayedMonth: Date
    @State private var selectedTime: Date = Date()
    
    init(calendar: Calendar, initialDate: Date?, onConfirm: @escaping (Date?) -> Void) {
        self.calendar = calendar
        self.onConfirm = onConfirm
        self.initialDate = initialDate
        _selectedDate = State(initialValue: initialDate)
        _displayedMonth = State(initialValue: initialDate ?? Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView {
                VStack(spacing: 24) {
                    quickOptions
                    calendarCard
                }
                .padding(20)
            }
            
            confirmButton
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        }
    }
}

extension TaskDatePickerView {
    private var header: some View {
        HStack {
               Button {
                   dismiss()
               } label: {
                   Image(systemName: "xmark")
                       .foregroundStyle(.secondary)
               }
    
               Spacer()
    
               Text("Select Date")
                   .font(.headline)
    
               Spacer()
    
               Button("Done") {
                   onConfirm(combinedDateIfNeeded())
                   dismiss()
               }
               .font(.body.weight(.semibold))
               .foregroundStyle(Color.saveTaskBackground)
           }
           .padding(.horizontal, 20)
           .padding(.vertical, 14)
    }
    
    private var quickOptions: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(QuickOption.allCases) { option in
                quickOptionButton(option)
            }
        }
    }
    
    private var calendarCard: some View {
        VStack(spacing: 16) {
            monthHeader
            weekdayHeader
            dayGrid
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
 
    private var monthHeader: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }
 
            Spacer()
 
            Text(monthTitle)
                .font(.headline)
 
            Spacer()
 
            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.primary)
    }
    
    private var weekdayHeader: some View {
        HStack {
            ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var dayGrid: some View {
        let days = generateDays(for: displayedMonth)
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(days) { day in
                dayCell(day)
            }
        }
    }
    
   private var confirmButton: some View {
           Button {
               onConfirm(combinedDateIfNeeded())
               dismiss()
           } label: {
               Text("Confirm Date")
                   .font(.body.weight(.semibold))
                   .frame(maxWidth: .infinity)
                   .padding(.vertical, 16)
                   .background(Color.saveTaskBackground)
                   .foregroundStyle(.white)
                   .clipShape(Capsule())
           }
       }
}

extension TaskDatePickerView {
    private struct CalendarDay: Identifiable {
        let id = UUID()
        let date: Date
        let dayNumber: Int
        let isWithinDisplayedMonth: Bool
    }
    
    private enum QuickOption: String, CaseIterable, Identifiable {
        case today = "Today"
        case tomorrow = "Tomorrow"
        case nextWeek = "Next Week"
        case noDate = "No Date"
 
        var id: String { rawValue }
 
        var icon: String {
            switch self {
            case .today: return "calendar"
            case .tomorrow: return "calendar"
            case .nextWeek: return "briefcase"
            case .noDate: return "circle.slash"
            }
        }
    }
    
    private func quickOptionButton(_ option: QuickOption) -> some View {
        let selected = isSelected(option)
        return Button {
            select(option)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: option.icon)
                Text(option.rawValue)
            }
            .font(.subheadline.weight(.medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(selected ? Color.saveTaskBackground.opacity(0.12) : Color(.tertiarySystemGroupedBackground))
            )
            .foregroundStyle(selected ? Color.saveTaskBackground : .primary)
        }
        .buttonStyle(.plain)
    }
 
    private func select(_ option: QuickOption) {
        let newDate = date(for: option)
        selectedDate = newDate
        if let newDate {
            displayedMonth = newDate
        }
    }
 
    private func date(for option: QuickOption) -> Date? {
        let today = calendar.startOfDay(for: Date())
        switch option {
        case .today:
            return today
        case .tomorrow:
            return calendar.date(byAdding: .day, value: 1, to: today)
        case .nextWeek:
            return calendar.date(byAdding: .day, value: 7, to: today)
        case .noDate:
            return nil
        }
    }
 
    private func isSelected(_ option: QuickOption) -> Bool {
        switch option {
        case .noDate:
            return selectedDate == nil
        default:
            guard let selectedDate, let optionDate = date(for: option) else { return false }
            return calendar.isDate(selectedDate, inSameDayAs: optionDate)
        }
    }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = calendar.locale ?? .autoupdatingCurrent
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: displayedMonth)
    }
 
    private func changeMonth(by value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) else { return }
        displayedMonth = newMonth
    }
    
    /// calendar.firstWeekday'e göre döndürülmüş hafta günü sembolleri.
    /// Bu sayede hangi Calendar (Pazar-first ya da Pazartesi-first) verilirse
    /// başlık ona otomatik uyum sağlıyor.
    private var weekdaySymbols: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        return Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
    }
    
    private func dayCell(_ day: CalendarDay) -> some View {
          let isSelectedDay = selectedDate.map { calendar.isDate($0, inSameDayAs: day.date) } ?? false
          return Button {
              selectedDate = day.date
          } label: {
              Text("\(day.dayNumber)")
                  .font(.subheadline.weight(isSelectedDay ? .bold : .regular))
                  .frame(width: 36, height: 36)
                  .background(
                      Circle()
                          .fill(isSelectedDay ? Color.saveTaskBackground : Color.clear)
                  )
                  .foregroundStyle(
                      isSelectedDay ? .white : (day.isWithinDisplayedMonth ? .primary : .secondary.opacity(0.5))
                  )
          }
          .buttonStyle(.plain)
      }
   
      /// Verilen ayın tam hafta grid'ini üretir (önceki/sonraki aydan taşan
      /// günler dahil), takvimin "6 satır x 7 sütun" görünümünü oluşturmak için.
      private func generateDays(for month: Date) -> [CalendarDay] {
          guard
              let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: monthInterval.end),
              let lastWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: lastDayOfMonth)
          else { return [] }
   
          var days: [CalendarDay] = []
          var current = firstWeekInterval.start
   
          while current < lastWeekInterval.end {
              let dayNumber = calendar.component(.day, from: current)
              let isWithinMonth = calendar.isDate(current, equalTo: month, toGranularity: .month)
              days.append(CalendarDay(date: current, dayNumber: dayNumber, isWithinDisplayedMonth: isWithinMonth))
   
              guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
              current = next
          }
   
          return days
      }
    
    /// Seçilen günü, "Add Time" açıksa saat/dakikayla birleştirip tek bir
    /// Date döner. Daha önce SetReminderView'da konuştuğumuz aynı mantık:
    /// günün year/month/day'i + seçilen hour/minute.
    private func combinedDateIfNeeded() -> Date? {
        guard let selectedDate else { return nil } 
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        return calendar.date(from: dateComponents)
    }
}

#Preview {
    TaskDatePickerView(
        calendar: {
            var cal = Calendar.autoupdatingCurrent
            cal.firstWeekday = 2
            return cal
        }(),
        initialDate: Date()
    ) { _ in }
}

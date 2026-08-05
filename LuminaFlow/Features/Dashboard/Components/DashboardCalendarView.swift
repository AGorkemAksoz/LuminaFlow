//
//  DashboardCalendarView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 17.03.2026.
//

import SwiftUI

struct DashboardCalendarView: View {
    
    @Binding var selectedDate: Date
    var calendar: Calendar
        
    private var weekDays: [Date] {
        guard
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start
        else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(weekTitle(for: weekDays))
                .luminaStyle(.monthYear)
                .bold()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: LuminaSpacing.m) {
                    ForEach(weekDays, id: \.self) { day in
                        let dayStart = calendar.startOfDay(for: day)
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                selectedDate = dayStart
                            }
                        } label: {
                            DashboardCalendarViewCell(
                                day: Self.weekdayFormatter.string(from: day).uppercased(),
                                date: calendar.component(.day, from: day),
                                isSelectedDay: calendar.isDate(day, inSameDayAs: selectedDate)
                            )
                        }
                        .buttonStyle(.plain)
                        .shadow(radius: calendar.isDate(day, inSameDayAs: selectedDate) ? 8 : 0 )
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.horizontal)
    }

    private func weekTitle(for days: [Date]) -> String {
        guard let first = days.first, let last = days.last else { return "" }

        let y1 = calendar.component(.year, from: first)
        let y2 = calendar.component(.year, from: last)
        let m1 = calendar.component(.month, from: first)
        let m2 = calendar.component(.month, from: last)

        if y1 == y2, m1 == m2 {
            return "\(Self.monthFormatter.string(from: first)) \(Self.yearFormatter.string(from: first))"
        }
        if y1 == y2 {
            return "\(Self.monthFormatter.string(from: first)) – \(Self.monthFormatter.string(from: last)) \(Self.yearFormatter.string(from: first))"
        }
        return "\(Self.monthFormatter.string(from: first)) \(Self.yearFormatter.string(from: first)) – \(Self.monthFormatter.string(from: last)) \(Self.yearFormatter.string(from: last))"
    }

    private static let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .autoupdatingCurrent
        f.dateFormat = "EEE"
        return f
    }()

    private static let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .autoupdatingCurrent
        f.dateFormat = "MMMM"
        return f
    }()

    private static let yearFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .autoupdatingCurrent
        f.dateFormat = "yyyy"
        return f
    }()
}

#Preview {
    DashboardCalendarView(selectedDate: .constant(Date()),
                          calendar: .autoupdatingCurrent)
}

struct DashboardCalendarViewCell: View {
    let day: String
    let date: Int
    var isSelectedDay: Bool

    let gradient = Gradient(colors: [Color.luminaSeedBlue,
                                       Color.luminaSeedBlue.opacity(0.8)])

    var body: some View {
        VStack(spacing: LuminaSpacing.s) {
            Text(day)
                .luminaStyle(isSelectedDay ? .dayLabelSelected : .dayLabel)
            Text(String(date))
                .luminaStyle(isSelectedDay ? .dateNumberSelected : .dateNumber)
            if isSelectedDay {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 6, height: 6)
                    .foregroundStyle(Color.white)
            }
        }
        .padding()
        .background(
            isSelectedDay
            ? AnyShapeStyle(LinearGradient(gradient: gradient, startPoint: .bottomLeading, endPoint: .topTrailing))
            : AnyShapeStyle(Color.white)
        )
        .clipShape(.rect(cornerRadius: 16))
    }
}

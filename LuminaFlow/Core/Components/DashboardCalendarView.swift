//
//  DashboardCalendarView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 17.03.2026.
//

import SwiftUI

struct DashboardCalendarView: View {
    let dummyCalendarData: [String: Int] = ["Mon": 11, "Tue" :12, "Wed": 13, "Thu": 14, "Fri": 15, "Sat": 16, "Sun": 17]
    
    let orderedDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("October 2023")
                .luminaStyle(.subheading)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: LuminaSpacing.m) {
                    // Sort by weekday order (or just alphabetically if you prefer)
                    ForEach(orderedDays, id: \.self) { dayKey in
                        if let date = dummyCalendarData[dayKey] {
                            DashboardCalendarViewCell(day: dayKey.uppercased(),
                                                      date: date)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }.padding(.horizontal)
    }
}
#Preview {
    DashboardCalendarView()
}


struct DashboardCalendarViewCell: View {
    let day: String
    let date: Int
    var body: some View {
        VStack(spacing: LuminaSpacing.s) {
            Text(day)
                .luminaStyle(.smallCaps)
            Text(String(date))
                .luminaStyle(.headline)
        }
        .padding()
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 16))
    }
    
}

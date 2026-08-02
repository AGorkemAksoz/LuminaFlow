//
//  DashboardTaskCellView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 3.04.2026.
//

import SwiftUI

struct DashboardTaskCellView: View {
    let selectedTask: TaskItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(selectedTask.title)
                    .luminaStyle(.taskTitle)
                HStack {
                    Image(systemName: "clock.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text(selectedTask.dueDate?.formatter() ?? "13:30")
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 8, height: 8)
                }
                .luminaStyle(.timeMetadata)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .padding(.horizontal)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

//#Preview {
//    DashboardTaskCellView()
//}


extension Date {
    func formatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24 saat formatı -> 19:23
        // formatter.dateFormat = "hh:mm" // 12 saat formatı -> 07:23
        formatter.timeZone = TimeZone.current // istersen belirli bir zaman dilimi verebilirsin
        
        return formatter.string(from: self)
    }
}

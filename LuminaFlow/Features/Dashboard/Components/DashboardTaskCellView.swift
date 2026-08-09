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
            
            VStack(alignment: .leading, spacing: 8) {
                Text(selectedTask.title)
                    .luminaStyle(.taskTitle)
                    .strikethrough(selectedTask.isFinished)
                if let reminder = selectedTask.reminder {
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text(reminder.formatted(date: .omitted, time: .shortened))
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 8, height: 8)
                    }
                    .luminaStyle(.timeMetadata)
                }
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

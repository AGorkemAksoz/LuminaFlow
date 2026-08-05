//
//  DashboardTaskList.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 30.06.2026.
//

import SwiftUI

struct DashboardTaskList: View {
    
    let tasks: [TaskItem]
    let isSpinning: Bool
    
    var body: some View {
        ZStack {
            if isSpinning {
                ProgressView()
                    .frame(width: 150, height: 150)
            } else {
                List(tasks) { task in
                    DashboardTaskCellView(selectedTask: task)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    let dummyTask = TaskItem(title: "Testing",
                             description: "Testing attenion please",
                             dueDate: Date(),
                             isFinished: false)
    DashboardTaskList(tasks: [dummyTask], isSpinning: false)
}

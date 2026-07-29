//
//  DashboardTaskList.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 30.06.2026.
//

import SwiftUI

struct DashboardTaskList: View {
    
    let tasks: [TaskItem] = [TaskItem(title: "Testing",
                              description: "1 million, 2 million",
                              dueDate: Date.now,
                              isFinished: true),
                         TaskItem(title: "Deneme",
                              description: "1 milyon, 2 milyon",
                              dueDate: Date.init(timeIntervalSince1970: 1781913600),
                              isFinished: false)
    ]
    
    var body: some View {
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

#Preview {
    DashboardTaskList()
}

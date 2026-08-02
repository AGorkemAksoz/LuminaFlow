//
//  DashboardViewModel.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 1.08.2026.
//

import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    
    //UI Listeners (Should be update on MainActor)
    @Published private(set) var tasks: [TaskItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Async Actor repository dependency
    private let repository: TaskRepository
    private let calendar: Calendar
    
    // User's selected date
    @Published var selectedDate: Date
    
    // Computed Properties
    var progress: Double {
        let finisedTasks = Double(tasks.filter(\.isFinished).count)
        let totalTasks = Double(tasks.count)
        guard totalTasks > 0 else { return 0 }
        return Double(finisedTasks / totalTasks)
    }
    
    var progressText: String {
        let finisedTasks = tasks.filter(\.isFinished).count
        let totalTasks = tasks.count
        return "\(finisedTasks) of \(totalTasks) tasks completed"
    }
    
    init(repository: TaskRepository,
         calendar: Calendar = .autoupdatingCurrent,
         initialDate: Date = Date()) {
        self.repository = repository
        self.calendar = calendar
        self.selectedDate = calendar.startOfDay(for: initialDate)
    }
    
    func loadTasks(for date: Date) async {
        do {
            isLoading = true
            defer { isLoading = false }
            
            let result = try await repository.fetchTasks(for: date)
            guard !Task.isCancelled else { return }
            tasks = result
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

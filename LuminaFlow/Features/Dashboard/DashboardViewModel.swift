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
    @Published private(set) var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    // User's selected date
    @Published var selectedDate: Date
    
    // Async Actor repository dependency
    private let repository: TaskRepository
    let calendar: Calendar
    
    init(repository: TaskRepository,
         calendar: Calendar = .autoupdatingCurrent,
         initialDate: Date = Date()) {
        self.repository = repository
        self.calendar = calendar
        self.selectedDate = calendar.startOfDay(for: initialDate)
    }
    
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
    
    // Alert functions
    func clearError() {
        errorMessage = nil
    }

    func retry() async {
        await loadTasks(for: selectedDate)
    }
}

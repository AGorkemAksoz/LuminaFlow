//
//  CreateTaskViewModel.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 3.08.2026.
//

import Foundation

@MainActor
final class CreateTaskViewModel: ObservableObject, Identifiable {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var dueDate: Date = Date()
    @Published private(set) var isSaving: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    // Async Actor repository dependency
    private let repository: TaskRepository
    let calendar: Calendar
    let id = UUID()
    
    init(repository: TaskRepository,
         calendar: Calendar = .autoupdatingCurrent,
         initialDueDate: Date = Date()) {
        self.repository = repository
        self.calendar = calendar
        self.dueDate = calendar.startOfDay(for: initialDueDate)
    }
    
    var onTaskCreated: (() -> Void)?
    
    func save() async {
        do {
            let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard trimmedTitle.count > 0 else {
                // TODO: Error types will add
                errorMessage = "Title can't be empty"
                return
            }
            
            isSaving = true
            defer { isSaving = false}
            
            let taskItem = TaskItem(title: trimmedTitle, description: description.isEmpty ? nil : description, dueDate: dueDate, isFinished: false)
            
            try await repository.add(taskItem)
            errorMessage = nil
            
            onTaskCreated?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Alert functions
    func clearError() {
        errorMessage = nil
    }
    
    func retry() async {
        await save()
    }
}

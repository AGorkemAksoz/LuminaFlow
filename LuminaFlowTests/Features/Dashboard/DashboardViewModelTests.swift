//
//  DashboardViewModelTests.swift
//  LuminaFlowTests
//
//  Created by Ali Görkem Aksöz on 2.08.2026.
//

import Foundation
import Testing
@testable import LuminaFlow

struct DashboardViewModelTests {
    
    @MainActor
    @Test
    func loadTasks_success_populatesTasks_andClearsError() async {
        // ARRANGE
        let task1 = TaskItem(title: "Do task 1", description: nil, dueDate: nil, isFinished: false)
        let task2 = TaskItem(title: "Do task 2", description: nil, dueDate: nil, isFinished: true)
        let mockTasks = [task1, task2]
        
        let repository = MockTaskRepository(tasksToReturn: mockTasks)
        let sut = DashboardViewModel(repository: repository)
        
        // ACT
        await sut.loadTasks(for: sut.selectedDate)
        
        // ASSERT
        #expect(sut.tasks.count == 2)
        #expect(sut.tasks.map(\.id) == [task1.id, task2.id])
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }
    
    @MainActor
    @Test
    func loadTasks_failure_setsErrorMessage() async {
        // ARRANGE
        let randomID = UUID()
        let repository = MockTaskRepository(errorToThrow: RepositoryError.notFound(randomID))
        let sut = DashboardViewModel(repository: repository)
        
        // ACT
        await sut.loadTasks(for: sut.selectedDate)
        
        // ASSERT
         #expect(sut.errorMessage != nil)
         #expect(sut.tasks.isEmpty)
         #expect(sut.isLoading == false)
    }
    
    @MainActor
    @Test
    func progress_and_progressText_calculateCorrectly() async {
        //ARRANGE
        let tasks = [
            TaskItem(title: "Task 1", description: nil, dueDate: nil, isFinished: true),
            TaskItem(title: "Task 2", description: nil, dueDate: nil, isFinished: false),
            TaskItem(title: "Task 3", description: nil, dueDate: nil, isFinished: false),
            TaskItem(title: "Task 4", description: nil, dueDate: nil, isFinished: false)
        ]
        
        let repository = MockTaskRepository(tasksToReturn: tasks)
        let sut = DashboardViewModel(repository: repository)
        
        //ACT
        await sut.loadTasks(for: sut.selectedDate)
        
        //ASSERT
        #expect(sut.progress == 0.25)
        #expect(sut.progressText == "1 of 4 tasks completed")
    }

}

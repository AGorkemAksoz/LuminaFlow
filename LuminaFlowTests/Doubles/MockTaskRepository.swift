//
//  MockTaskRepository.swift
//  LuminaFlowTests
//
//  Created by Ali Görkem Aksöz on 2.08.2026.
//

import Foundation
import Testing
@testable import LuminaFlow

actor MockTaskRepository: TaskRepository {
    private let tasksToReturn: [TaskItem]
    private let errorToThrow: Error?

    init(tasksToReturn: [TaskItem] = [], errorToThrow: Error? = nil) {
        self.tasksToReturn = tasksToReturn
        self.errorToThrow = errorToThrow
    }

    func fetchTasks(for date: Date) async throws -> [TaskItem] {
        if let errorToThrow { throw errorToThrow }
        return tasksToReturn
    }
    func add(_ taskItem: TaskItem) async throws {}     // VM testinde kullanılmıyor
    func update(_ taskItem: TaskItem) async throws {}  // şimdilik boş bırak
    func delete(_ id: UUID) async throws { }
}

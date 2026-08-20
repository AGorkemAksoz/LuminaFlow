//
//  TaskRepository.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 30.07.2026.
//

import Foundation

enum RepositoryError: Error, Equatable {
    case duplicate(UUID)
    case notFound(UUID)
}

protocol TaskRepository: Sendable {
    func fetchTasks(for date: Date) async throws -> [TaskItem]
    func add(_ taskItem: TaskItem) async throws
    func update(_ taskItem: TaskItem) async throws
    func delete(_ id: UUID) async throws
}

//
//  ReminderScheduler.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 10.08.2026.
//

import Foundation

protocol ReminderScheduler {
    func requestAuthorization() async -> Bool
    func schedule(for task: TaskItem) async throws
    func cancel(for taskID: UUID) async
}

/// Test ve Preview'larda gerçek bildirim göndermeden kullanılır.
final class NoOpReminderScheduler: ReminderScheduler {
    func requestAuthorization() async -> Bool { true }
    func schedule(for task: TaskItem) async throws { }
    func cancel(for taskID: UUID) async { }
}

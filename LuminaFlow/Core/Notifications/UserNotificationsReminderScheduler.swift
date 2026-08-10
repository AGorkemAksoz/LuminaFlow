//
//  UserNotificationsReminderScheduler.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 10.08.2026.
//

import Foundation
@preconcurrency import UserNotifications

enum ReminderSchedulerError: Error, Equatable {
    case notAuthorized
}

final class UserNotificationsReminderScheduler: ReminderScheduler {
    
    private let notificationCenter: UNUserNotificationCenter
    private let calendar: Calendar
    
    init(notificationCenter: UNUserNotificationCenter = .current(), calendar: Calendar = .autoupdatingCurrent) {
        self.notificationCenter = notificationCenter
        self.calendar = calendar
    }
    
    func requestAuthorization() async -> Bool {
        do {
            return try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }
    
    func schedule(for task: TaskItem) async throws {
        // reminder yok veya task tamamlanmış -> mevcut pending notification'ı iptal et, yenisini kurma
        guard let reminderDate = task.reminder, !task.isFinished else {
            await cancel(for: task.id)
            return
        }
        
        guard reminderDate > Date() else {
            await cancel(for: task.id)
            return
        }
        
        let settings = await notificationCenter.notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            throw ReminderSchedulerError.notAuthorized
        }
        
        // update = cancel + schedule
        await cancel(for: task.id)
        
        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: makeContent(for: task),
            trigger: makeTrigger(for: reminderDate)
        )
        
        try await notificationCenter.add(request)
    }
    
    func cancel(for taskID: UUID) async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [taskID.uuidString])
    }
}

// MARK: - Private Helpers
extension UserNotificationsReminderScheduler {
    private func makeContent(for task: TaskItem) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.dueDate != nil ? "Due soon" : "Reminder"
        content.sound = .default
        return content
    }
    
    private func makeTrigger(for date: Date) -> UNCalendarNotificationTrigger {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
}

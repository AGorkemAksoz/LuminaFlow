//
//  InMemoryTaskRepositoryTests.swift
//  LuminaFlowTests
//
//  Created by Ali Görkem Aksöz on 1.08.2026.
//

import Foundation
import Testing
@testable import LuminaFlow

struct InMemoryTaskRepositoryTests {
    
    // Deterministik ortam: UTC calendar
    private var utcCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }
    
    @Test
    func fetchTasks_returnsOnlyThatDaysTasks_sortedByTime() async throws {
        // ARRANGE
        let cal = utcCalendar
        func at(_ hour: Int, day: Int) -> Date {
            cal.date(from: DateComponents(year: 2026, month: 7, day: day, hour: hour))!
        }
        let early    = TaskItem(title: "Early",  description: nil, dueDate: at(8,  day: 30), reminder: .now, isFinished: false, priority: .medium)
        let late     = TaskItem(title: "Late",   description: nil, dueDate: at(10, day: 30), reminder: .now, isFinished: false, priority: .medium)
        let otherDay = TaskItem(title: "Other",  description: nil, dueDate: at(9,  day: 31), reminder: .now, isFinished: false, priority: .medium)
        let noDate   = TaskItem(title: "NoDate", description: nil, dueDate: nil,             reminder: .now, isFinished: false, priority: .medium)
        let sut = InMemoryTaskRepository(
            tasks: [late, otherDay, noDate, early],   // kasıtlı KARIŞIK sıra
            calendar: cal
        )
        let july30 = cal.date(from: DateComponents(year: 2026, month: 7, day: 30))!
        // ACT
        let result = try await sut.fetchTasks(for: july30)
        // ASSERT
        #expect(result.count == 2)                          // otherDay + noDate elendi
        #expect(result.map(\.id) == [early.id, late.id])    // hem filtre hem SIRALAMA
    }
    
    @Test func add_throwsDuplicate_whenIDAlreadyExists() async throws {
        // ARRANGE
        let sharedID = UUID()
        
        let existingTask = TaskItem(id: sharedID, title: "Existing Task", description: nil, dueDate: nil, reminder: .now, isFinished: false, priority: .medium)
        let duplicateTask = TaskItem(id: sharedID, title: "Duplicate Task", description: nil, dueDate: nil, reminder: .now, isFinished: false, priority: .medium)
        
        let sut = InMemoryTaskRepository(
            tasks: [existingTask]
        )
        
        // ACT&ASSERT
        await #expect(throws: RepositoryError.duplicate(sharedID), performing: {
            try await sut.add(duplicateTask)
        })
    }
}

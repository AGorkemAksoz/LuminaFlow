//
//  LuminaFlowApp.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.03.2026.
//

import SwiftUI

@main
struct LuminaFlowApp: App {
    private let container:DependencyContainer
    
    init() {
        do {
            let persistence = try PersistenceController()
            container = DependencyContainer(persistenceController: persistence)
        } catch {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            DashboardView(
                viewModel: container.makeDashboardViewModel(),
                makeCreateTaskViewModel: { date in
                    container.makeCreateTaskViewModel(initialDueDate: date)
                }
            )

        }
    }
}

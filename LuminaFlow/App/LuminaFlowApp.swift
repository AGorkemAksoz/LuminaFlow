//
//  LuminaFlowApp.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.03.2026.
//

import SwiftUI

@main
struct LuminaFlowApp: App {
    private let container = DependencyContainer()
    
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

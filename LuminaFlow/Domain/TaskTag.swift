//
//  TaskCategory.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 17.08.2026.
//

import Foundation

enum TaskTag: String, CaseIterable, Identifiable {
    case work, strategy, personal
    case wellness, education, finance, fitness
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .work: "Work"
        case .strategy: "Strategy"
        case .personal: "Personal"
        case .wellness: "Wellness"
        case .education: "Education"
        case .finance: "Finance"
        case .fitness: "Fitness"
        }
    }
    
    var icon: String {
        switch self {
        case .work: "briefcase.fill"
        case .strategy: "lightbulb.fill"
        case .wellness: "figure.mind.and.body"
        case .personal: "person.fill"
        case .education: "graduationcap.fill"
        case .finance: "dollarsign.circle.fill"
        case .fitness: "figure.strengthtraining.traditional"
        }
    }
}

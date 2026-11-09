//
//  SubtaskDrafting.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 9.11.2026.
//

import Foundation

@MainActor
protocol SubtaskDrafting: ObservableObject {
    var title: String { get }          // header’daki task adı
    var subtaskItems: [SubtaskItem] { get set }
    var draftTitle: String { get set }
    var canAdd: Bool { get }
    func addDraft()
    func toggle(_ item: SubtaskItem)
    func delete(_ item: SubtaskItem)
    func move(idString: String, onto target: SubtaskItem)
}

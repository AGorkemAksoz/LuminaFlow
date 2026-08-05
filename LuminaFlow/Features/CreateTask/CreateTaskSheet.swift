//
//  CreateTaskSheet.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.07.2026.
//

import SwiftUI

struct CreateTaskSheet: View {
    @ObservedObject private var viewModel: CreateTaskViewModel
    
    @Environment(\.dismiss) var dismiss
    
    
    init(viewModel: CreateTaskViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            cancelButton
            
            titleAndDescriptionTextField
            
            taskChipsGridView
            
            Spacer()
            
            saveButton
        }
        .alert("Couldn't save task",
               isPresented: Binding(get: { viewModel.errorMessage != nil},
                                    set: { if !$0 {viewModel.clearError()}})) {
            Button("Try Again") {
                Task { await viewModel.retry() }
            }
            Button("OK", role: .cancel) { }
        } message: { Text(viewModel.errorMessage ?? "") }
    }
}

#Preview {
    let container = DependencyContainer()
    CreateTaskSheet(viewModel: container.makeCreateTaskViewModel())
}

// MARK: - UI Components
extension CreateTaskSheet {
    private var cancelButton: some View {
        HStack {
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Text("Cancel")
                    .luminaStyle(.createTaskNavCancel)
            })
                .padding()
        }
    }
    
    private var titleAndDescriptionTextField: some View {
        VStack {
            TextField(text: $viewModel.title) {
                Text("What needs to be done?")
                    .luminaStyle(.createTaskHeadline)
            }
            
            TextField(text: $viewModel.description) {
                Text("Add details...")
                    .luminaStyle(.createTaskDetail)
            }
        }
        .padding()
    }
    
    private var taskChipsGridView: some View {
        HStack {
            VStack {
                HStack {
                    makeChipLabel(for: .date)
                    makeChipLabel(for: .priority)
                }
                HStack {
                    makeChipLabel(for: .reminder)
                    makeChipLabel(for: .inbox)
                }
            }
            .padding()
            Spacer()
        }
    }
    
    private var saveButton: some View {
        HStack {
            Button {
                Task { await viewModel.save() }
            } label: {
                Text("Save Task")
                    .luminaStyle(.createTaskSaveButton)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }
            .background(Color.saveTaskBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 10)
            .padding(.bottom)
            .disabled(viewModel.isSaving)
        }
    }
}

// MARK: - Viewbuilder Functions
extension CreateTaskSheet {
    @ViewBuilder
    private func makeChipLabel(for chipLabelCase: CreateTaskChipKind) -> some View {
        HStack {
            Image(systemName: chipLabelCase.template.imageName)
            Text(chipLabelCase.template.title)
        }
        .padding(8)
        .background(chipLabelCase.template.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .luminaStyle(chipLabelCase.template.typography)

    }
}

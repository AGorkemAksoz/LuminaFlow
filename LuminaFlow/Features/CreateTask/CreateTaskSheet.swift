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
    
    @State private var isPresentingDatePicker = false
    @State private var isPresentingPriorityPicker = false
    @State private var isPresentingReminderSheet = false
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
        .sheet(isPresented: $isPresentingDatePicker) {
//            DatePicker("Select a date",
//                       selection: $viewModel.dueDate,
//                       displayedComponents: .date)
            
            TaskDatePickerView(calendar: .autoupdatingCurrent,
                               initialDate: viewModel.dueDate) { date in
                if let date {
                    viewModel.dueDate = viewModel.calendar.startOfDay(for: date)
                }
            }
        }
        .sheet(isPresented: $isPresentingPriorityPicker) {
            PriorityPickView(isSelected: $viewModel.priority)
                .presentationDetents([.large])
        }
        .sheet(isPresented: $isPresentingReminderSheet) {
            ReminderPickSheet(selectedDate: $viewModel.reminderDate,
                              calendar: viewModel.calendar,
                              baseDate: Date())
            .presentationDetents([.height(300)])
        }
    }
}

#Preview {
    let container = DependencyContainer(persistenceController: .preview)
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
                    Button {
                        isPresentingDatePicker = true
                    } label: {
                        makeChipLabel(for: .date(label: viewModel.dueDateChipTitle))
                    }

                    Button {
                        isPresentingPriorityPicker = true
                    } label: {
                        makeChipLabel(for: .priority(label: viewModel.priority.title))
                    }

                }
                HStack {
                    Button {
                        isPresentingReminderSheet = true
                    } label: {
                        makeChipLabel(for: .reminder(label: viewModel.reminderChipTitle))
                    }

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
            .clipShape(RoundedRectangle(cornerRadius: 16))
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

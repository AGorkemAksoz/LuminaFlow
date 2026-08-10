//
//  DashboardView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 2.08.2026.
//

import SwiftUI

struct DashboardView: View {
    
    private let makeCreateTaskVM: (Date) -> CreateTaskViewModel
    
    @StateObject private var viewModel: DashboardViewModel
    
    @State private var createTaskViewModel: CreateTaskViewModel?
    
    init(
        viewModel: @autoclosure @escaping () -> DashboardViewModel,
        makeCreateTaskViewModel: @escaping (Date) -> CreateTaskViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.makeCreateTaskVM = makeCreateTaskViewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.luminaBackground
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: LuminaSpacing.xs) {
                DashboardViewNavigationBar()
                DashboardCalendarView(selectedDate: $viewModel.selectedDate,
                                      calendar: viewModel.calendar)
                DashboardDailyProgressView(progressText: viewModel.progressText,
                                           progress: viewModel.progress)
                DashboardTitleView()
                DashboardTaskList(tasks: viewModel.tasks, isSpinning: viewModel.isLoading, onToggleTask: { task in
                    Task { await viewModel.toggleFinished(task) }
                })
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: 72) // FAB yüksekliği + margin
                }
            }
            
            Button {
                let vm = makeCreateTaskVM(viewModel.selectedDate)
                vm.onTaskCreated = { [weak viewModel] in
                    createTaskViewModel = nil
                    Task { await viewModel?.loadTasks(for: viewModel?.selectedDate ?? Date())}
                }
                createTaskViewModel = vm
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(Color.luminaAccentBlue)
                    .clipShape(Circle())

            }
            .padding([.trailing, .bottom])
            .task(id: viewModel.selectedDate) {
                await viewModel.loadTasks(for: viewModel.selectedDate)
            }
            .alert(
                "Couldn't load tasks",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.clearError() } }
                ),
                actions: {
                    Button("Try Again") {
                        Task { await viewModel.retry() }
                    }
                    Button("OK", role: .cancel) { }
                },
                message: {
                    Text(viewModel.errorMessage ?? "")
                }
            )
            .sheet(item: $createTaskViewModel) { vm in
                CreateTaskSheet(viewModel: vm)
            }
        }
    }
}

#Preview {
    let container = DependencyContainer(persistenceController: .preview)
    
    DashboardView(
        viewModel: container.makeDashboardViewModel(),
        makeCreateTaskViewModel: { date in
            container.makeCreateTaskViewModel(initialDueDate: date)
        }
    )

}


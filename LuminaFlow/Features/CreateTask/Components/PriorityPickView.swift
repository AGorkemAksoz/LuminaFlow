//
//  PriorityPickView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 7.08.2026.
//

import SwiftUI

struct PriorityPickView: View {
    @Binding var isSelected: TaskPriority
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Set Priority")
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.secondary)
                }
            }
            .font(LuminaFont.usernameFont())
            .foregroundStyle(Color.luminaDarkNavy)
            .padding()
            
            List(TaskPriority.allCases, id: \.self) { priority in
                Button {
                    isSelected = priority
                } label: {
                    PriorityPickCell(priority: priority,
                                     isSelected: isSelected == priority)
                }

            }
            .buttonStyle(.plain)
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Confirm")
                        .luminaStyle(.createTaskSaveButton)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .background(Color.saveTaskBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 10)
                .padding(.bottom)
            }
        }
    }
}


struct PriorityPickCell: View {
    let priority: TaskPriority
    let isSelected: Bool
    var body: some View {
        HStack() {
            Image(systemName: priority.iconName)
                .resizable()
                .frame(width: 20, height: 20)
                .padding(10)
                .background(priority == .urgent ? Color.red.opacity(0.15) : Color.personalTagBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                Text(priority.title)
                    .font(LuminaFont.taskTitleFont())
                    .foregroundStyle(Color.luminaDarkNavy)
                Text(priority.description)
                    .font(LuminaFont.welcomeMessageFont())
                    .foregroundStyle(Color.luminaMutedSlate)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .foregroundStyle(.white)
                    .background(Color.luminaSeedBlue)
                    .clipShape(Circle())
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray)
            }

        }
        .padding()
        .background(isSelected ? Color.chipPriorityBackground : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    PriorityPickView(isSelected: .constant(.medium))
}

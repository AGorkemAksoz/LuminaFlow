//
//  CreateTaskSheet.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.07.2026.
//

import SwiftUI

struct CreateTaskSheet: View {
    var body: some View {
        VStack {
            HStack {
                Text("Cancel")
                    .luminaStyle(.createTaskNavCancel)
            }
        }
    }
}

#Preview {
    CreateTaskSheet()
}

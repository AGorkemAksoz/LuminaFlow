//
//  DashboardTitleView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 3.04.2026.
//

import SwiftUI

struct DashboardTitleView: View {
    var body: some View {
        Text("Tasks")
            .luminaStyle(.sectionHeadline)
            .padding(.leading)
            .padding(.vertical, 8)
    }
}

#Preview {
    DashboardTitleView()
}

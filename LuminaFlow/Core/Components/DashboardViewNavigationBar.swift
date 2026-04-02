//
//  DashboardViewNavigationBar.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 17.03.2026.
//

import SwiftUI

struct DashboardViewNavigationBar: View {
    var body: some View {
        HStack(alignment: .center) {
            imageView
            VStack(alignment: .leading, spacing: LuminaSpacing.s) {
                greetingLabel
                userNameLabel
            }
            Spacer()
            notificationIcon
        }
        .padding(.horizontal)
    }
}

extension DashboardViewNavigationBar {
    private var imageView: some View {
        Image(systemName: "person.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .padding()
            .background(
                Color.white
            )
            .clipShape(Circle())
    }
    
    private var greetingLabel: some View {
        Text("GOOD MORNING")
            .luminaStyle(.smallCaps)
    }
    
    private var userNameLabel: some View {
        Text("Alex Johnson")
            .luminaStyle(.subheading).bold()
    }
    
    private var notificationIcon: some View {
        Image(systemName: "bell.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .padding()
            .background(
                Color.white
            )
            .clipShape(Circle())
    }
}

#Preview {
    DashboardViewNavigationBar()
}

//
//  ContentView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.03.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.luminaBackground
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: LuminaSpacing.l) {
                DashboardViewNavigationBar()
                DashboardCalendarView()
                Spacer()
            }
            
        }
    }
}

#Preview {
    ContentView()
}

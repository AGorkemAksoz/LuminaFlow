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
            VStack(alignment: .leading, spacing: LuminaSpacing.xs) {
                DashboardViewNavigationBar()
                DashboardCalendarView()
                DashboardDailyProgressView()
                DashboardTitleView()
                DashboardTaskList()
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        print("Add a new task")
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundStyle(Color.white)
                            .background(Color.luminaAccentBlue)
                            .clipShape(Circle())

                    }

                }
                .padding([.trailing, .bottom])
            }
        }
    }
}

#Preview {
    ContentView()
}

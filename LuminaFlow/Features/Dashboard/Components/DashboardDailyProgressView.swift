//
//  DashboardDailyProgressView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 3.04.2026.
//

import SwiftUI

struct DashboardDailyProgressView: View {
    
    let progressText: String
    let progress: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Progress")
                    .luminaStyle(.progressHeadline)
                Text(progressText)
                    .luminaStyle(.progressState)
            }
            
            Spacer()
            
            ProgressView(value: progress)
                .frame(width: 90)
                .progressViewStyle(ThickProgressStyle(height: 10))
        }
        .padding(.horizontal)
        .frame(height: 70)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

#Preview {
    DashboardDailyProgressView(progressText: "4 of 7 tasks completed",
                               progress: 0.55)
}

struct ThickProgressStyle: ProgressViewStyle {
    var height: CGFloat = 20.0
    var color: Color = .luminaSeedBlue

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Arka plan (Boş kısım)
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color(.systemGray5))
                    .frame(height: height)

                // Ön plan (Dolu kısım)
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: height)
            }
        }
        .frame(height: height) // ProgressView'un kaplayacağı alanı belirler
    }
}

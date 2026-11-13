//
//  SubtasksView.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 10.11.2026.
//

import SwiftUI

// MARK: - Theme Configuration (Hex Kodları ile)
struct SubtaskTheme {
    // Kendi Color extension'ınıza göre hex string'leri buralara yazabilirsiniz
    var primaryAccent: Color = Color(hex: "3B56F5")         // Mavi accent (0/3 rozet, Edit butonu ve tamamlanan checkbox)
    var textPrimary: Color = Color(hex: "1F2437")           // Ana başlık yazıları
    var textSecondary: Color = Color(hex: "3B56F5")         // Alt zaman bilgisi yazısı ("Tomorrow, 2:00 PM")
    var backgroundCard: Color = Color(hex: "FFFFFF")        // Ana kart arka planı (Beyaz)
    var backgroundSelectedRow: Color = Color(hex: "F4F6F9") // Seçili/odaktaki satır arka planı (Hafif gri-mavi)
    var circleBorder: Color = Color(hex: "D1D5DB")          // Radio/checkbox boş çember rengi
    var dragHandle: Color = Color(hex: "9CA3AF")            // Sağ taraftaki 6 noktalı sürükleme ikonu rengi
    var divider: Color = Color(hex: "E5E7EB")               // Satırlar arası ayırıcı çizgi rengi
    var badgeBackground: Color = Color(hex: "EAEEFF")       // "0/3" rozet arka planı (Çok açık mavi)
}

// MARK: - Main Subtasks View
struct SubtasksView: View {
    var theme: SubtaskTheme = SubtaskTheme()
    
    @Binding var items: [SubtaskItem]
    
    
    var completedCount: Int {
        items.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header Section
            headerView
            
            // Subtasks Card Container
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    SubtaskRowView(
                        item: item,
                        theme: theme,
                        onToggle: {
                            items[index].isCompleted.toggle()
                        }
                    )
                    
                    if index < items.count - 1 {
                        Divider()
                            .background(theme.divider)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(theme.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
        }
        .padding()
    }
    
    private var headerView: some View {
        HStack(spacing: 8) {
            Text("Subtasks")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(theme.textPrimary)
            
            Text("\(completedCount)/\(items.count)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(theme.primaryAccent)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(theme.badgeBackground)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Row Item View
struct SubtaskRowView: View {
    let item: SubtaskItem
    let theme: SubtaskTheme
    var onToggle: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Checkbox Circle
            Button(action: onToggle) {
                Circle()
                    .strokeBorder(item.isCompleted ? theme.primaryAccent : theme.circleBorder, lineWidth: 2)
                    .background(
                        Circle()
                            .fill(item.isCompleted ? theme.primaryAccent : Color.clear)
                    )
                    .frame(width: 22, height: 22)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(item.isCompleted ? 1 : 0)
                    )
            }
            .buttonStyle(.plain)
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(theme.textPrimary)
                    .strikethrough(item.isCompleted, color: theme.textPrimary.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.clear)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(hex: "F9FAFB") // Arka plan
            .ignoresSafeArea()
        SubtasksView(items: .constant([SubtaskItem(title: "Add some subtasks", isCompleted: false)]))
    }
}

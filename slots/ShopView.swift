//
//  ShopView.swift
//  slots
//
//  Created by Francesco on 01/04/25.
//

import SwiftUI

struct ShopItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Int
    let icon: String
}


struct ShopView: View {
    let shopItems: [ShopItem]
    let credits: Int
    let hasAutoSpin: Bool
    let hasLuckyCharm: Bool
    let hasMultiplierBoost: Bool
    let hasBigWinInsurance: Bool
    
    let hasFreeSpins: Bool
    let hasJackpotBooster: Bool
    let hasDoubleCredits: Bool
    let hasGuaranteedJackpot: Bool
    
    var onClose: () -> Void
    var onPurchase: (ShopItem) -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.indigo, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text("CASINO SHOP")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("€\(credits)")
                        .font(.title2.bold())
                        .foregroundColor(.yellow)
                        .padding(.trailing)
                }
                .padding(.vertical)
                .background(Color.black.opacity(0.6))
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(shopItems, id: \.name) { item in
                            ShopItemCard(
                                item: item,
                                isOwned: isItemOwned(item),
                                credits: credits,
                                onPurchase: { onPurchase(item) }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    func isItemOwned(_ item: ShopItem) -> Bool {
        switch item.name {
        case "Auto Spin": return hasAutoSpin
        case "Amuleto Fortunato": return hasLuckyCharm
        case "Boost Moltiplicatore": return hasMultiplierBoost
        case "Assicurazione Vincita": return hasBigWinInsurance
        
        case "Giri Gratuiti": return hasFreeSpins
        case "Booster Jackpot": return hasJackpotBooster
        case "Crediti Doppi": return hasDoubleCredits
        case "Jackpot Garantito": return hasGuaranteedJackpot
            
        default: return false
        }
    }
}

struct ShopItemCard: View {
    let item: ShopItem
    let isOwned: Bool
    let credits: Int
    var onPurchase: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: item.icon)
                    .font(.system(size: 24))
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isOwned {
                    Label("", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Button(action: onPurchase) {
                        Text("€\(item.price)")
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(credits >= item.price ? Color.blue : Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(credits < item.price)
                }
            }
            .padding([.horizontal, .top])
            
            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .padding(.horizontal)
        }
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: isHovering ? Color.gray.opacity(0.4) : Color.gray.opacity(0.2), 
                        radius: isHovering ? 4 : 2, 
                        x: 0, 
                        y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isOwned ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
    }
}

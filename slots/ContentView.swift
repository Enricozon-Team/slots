//
//  ContentView.swift
//  slots
//
//  Created by Francesco on 31/03/25.
//

import SwiftUI

struct SlotView: View {
    let symbol: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.6))
                .frame(width: 80, height: 120)
            
            Text(symbol)
                .font(.system(size: 60))
        }
    }
}

struct SpinControlsView: View {
    let credits: Int
    let betAmount: Int
    let hasAutoSpin: Bool
    var onDecreaseBet: () -> Void
    var onIncreaseBet: () -> Void
    var onAllIn: () -> Void
    var onSpin: () -> Void
    var onAutoSpin: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Puntata: €\(betAmount)")
                    .foregroundColor(.white)
                
                if hasAutoSpin {
                    Button(action: onAutoSpin) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.green)
                    }
                    .disabled(credits < betAmount)
                }
            }
            .padding()
            
            HStack {
                Button("-") {
                    onDecreaseBet()
                }
                .buttonStyle(BetButtonStyle())
                
                Button("GIRA") {
                    onSpin()
                }
                .disabled(credits < betAmount)
                .buttonStyle(SpinButtonStyle())
                .padding()
                
                Button("+") {
                    onIncreaseBet()
                }
                .buttonStyle(BetButtonStyle())
            }
            
            HStack(alignment: .center) {
                Button("ALL IN") {
                    onAllIn()
                }
                .foregroundColor(.primary)
            }
        }
    }
}

struct AutoSpinView: View {
    let autoSpinCount: Int
    let isInfinite: Bool
    var onStop: () -> Void
    
    var body: some View {
        VStack {
            Text(isInfinite ? "Auto Spin: ∞" : "Auto Spin: \(autoSpinCount)")
                .foregroundColor(.white)
                .padding()
            
            Button("Ferma Auto Spin") {
                onStop()
            }
            .buttonStyle(SpinButtonStyle())
            .padding(.bottom, 46)
        }
    }
}

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var symbols = ["🍎", "🍋", "🍒", "💎", "7️⃣", "🍀"]
    @State private var numbers = [0, 1, 2]
    @State private var credits = 1000
    @State private var betAmount = 10
    @State private var winText = ""
    @State private var showWin = false
    
    @State private var showShop = false
    @State private var hasAutoSpin = false
    @State private var autoSpinCount = 0
    @State private var isAutoSpinning = false
    @State private var isInfiniteAutoSpin = false
    @State private var hasLuckyCharm = false
    @State private var hasMultiplierBoost = false
    @State private var hasBigWinInsurance = false
    
    @State private var hasFreeSpins = false
    @State private var freeSpinsRemaining = 0
    @State private var hasJackpotBooster = false
    @State private var hasDoubleCredits = false
    @State private var hasGuaranteedJackpot = false
    @State private var doubleCreditSpinsRemaining = 0
    
    let background = LinearGradient(gradient: Gradient(colors: [.purple, .black]), startPoint: .top, endPoint: .bottom)
    
    let shopItems = [
        ShopItem(name: "Auto Spin", description: "Gira automaticamente all'infinito", price: 500, icon: "arrow.triangle.2.circlepath"),
        ShopItem(name: "Amuleto Fortunato", description: "Aumenta la probabilità di vincita", price: 300, icon: "leaf"),
        ShopItem(name: "Boost Moltiplicatore", description: "Aumenta i moltiplicatori di vincita", price: 700, icon: "bolt.fill"),
        ShopItem(name: "Assicurazione Vincita", description: "Garantisce almeno €5 per ogni giro", price: 1000, icon: "shield.fill"),
        
        ShopItem(name: "Giri Gratuiti", description: "Ottieni 5 giri gratuiti", price: 200, icon: "gift.fill"),
        ShopItem(name: "Booster Jackpot", description: "Aumenta le probabilità di jackpot del 20%", price: 800, icon: "star.fill"),
        ShopItem(name: "Crediti Doppi", description: "Raddoppia i crediti vinti per 5 giri", price: 600, icon: "dollarsign.circle.fill"),
        ShopItem(name: "Jackpot Garantito", description: "Garantisce un jackpot 777 al prossimo giro! Utilizzabile una sola volta.", price: 4500, icon: "crown.fill")
    ]
    
    var body: some View {
        ZStack {
            background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    //Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    //    Image(systemName: "xmark.circle.fill")
                    //        .font(.title)
                    //        .foregroundColor(.white)
                    //}
                    //.padding()
                    
                    Button(action: { showShop = true }) {
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Text("Crediti: €\(credits)")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gray, lineWidth: 3)
                        )
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            SlotView(symbol: symbols[numbers[index]])
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                ZStack {
                    Text(winText)
                        .bold()
                        .foregroundColor(.yellow)
                        .opacity(winText.isEmpty ? 0 : 1)
                }
                .frame(height: 30)
                
                if isAutoSpinning {
                    AutoSpinView(autoSpinCount: autoSpinCount, isInfinite: isInfiniteAutoSpin) {
                        isAutoSpinning = false
                        autoSpinCount = 0
                        isInfiniteAutoSpin = false
                    }
                } else {
                    SpinControlsView(
                        credits: credits,
                        betAmount: betAmount,
                        hasAutoSpin: hasAutoSpin,
                        onDecreaseBet: decreaseBet,
                        onIncreaseBet: increaseBet,
                        onAllIn: allIn,
                        onSpin: spin,
                        onAutoSpin: startAutoSpin
                    )
                }
            }
            
            if showShop {
                ShopView(
                    shopItems: shopItems,
                    credits: credits,
                    hasAutoSpin: hasAutoSpin,
                    hasLuckyCharm: hasLuckyCharm,
                    hasMultiplierBoost: hasMultiplierBoost,
                    hasBigWinInsurance: hasBigWinInsurance,
                    hasFreeSpins: hasFreeSpins,
                    hasJackpotBooster: hasJackpotBooster,
                    hasDoubleCredits: hasDoubleCredits,
                    hasGuaranteedJackpot: hasGuaranteedJackpot,
                    
                    onClose: { showShop = false },
                    onPurchase: purchaseItem
                )
            }
        }
        .onAppear {
            if hasAutoSpin && isAutoSpinning && autoSpinCount > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    autoSpin()
                }
            }
        }
    }
    
    func decreaseBet() {
        if betAmount > 10 {
            betAmount -= 10
        }
    }
    
    func increaseBet() {
        if betAmount < credits {
            betAmount += 10
        }
    }
    
    func allIn() {
        betAmount = credits
    }
    
    func spin() {
        if freeSpinsRemaining > 0 {
            freeSpinsRemaining -= 1
            winText = "Giro gratuito! Rimanenti: \(freeSpinsRemaining)"
        } else if credits < betAmount {
            return
        } else {
            credits -= betAmount
        }
        
        
        if hasGuaranteedJackpot {
            let sevenIndex = symbols.firstIndex(of: "7️⃣") ?? 0
            
            numbers[0] = sevenIndex
            numbers[1] = sevenIndex
            numbers[2] = sevenIndex
            
            hasGuaranteedJackpot = false
        } else {
            for i in 0..<3 {
                if hasLuckyCharm && Int.random(in: 0...100) < 15 {
                    numbers[i] = Int.random(in: 3..<symbols.count)
                } else if hasJackpotBooster && Int.random(in: 0...100) < 20 {
                    numbers[i] = symbols.firstIndex(of: "7️⃣") ?? Int.random(in: 0..<symbols.count)
                } else {
                    numbers[i] = Int.random(in: 0..<symbols.count)
                }
            }
        }
        
        checkWin()
        
        if hasDoubleCredits && doubleCreditSpinsRemaining > 0 {
            doubleCreditSpinsRemaining -= 1
            if doubleCreditSpinsRemaining == 0 {
                hasDoubleCredits = false
                winText = winText + " Effetto Crediti Doppi terminato!"
            }
        }
    }
    
    func autoSpin() {
        if isAutoSpinning && credits >= betAmount && (autoSpinCount > 0 || isInfiniteAutoSpin) {
            spin()
            
            if (!isInfiniteAutoSpin) {
                autoSpinCount -= 1
            }
            
            if autoSpinCount > 0 || isInfiniteAutoSpin {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.autoSpin()
                }
            } else {
                isAutoSpinning = false
            }
        } else if credits < betAmount {
            isAutoSpinning = false
            autoSpinCount = 0
            isInfiniteAutoSpin = false
            winText = "Auto Spin fermato: crediti insufficienti!"
        }
    }
    
    func startAutoSpin() {
        isAutoSpinning = true
        isInfiniteAutoSpin = true
        autoSpin()
    }
    
    func purchaseItem(_ item: ShopItem) {
        if credits >= item.price {
            credits -= item.price
            
            switch item.name {
            case "Auto Spin":
                hasAutoSpin = true
            case "Amuleto Fortunato":
                hasLuckyCharm = true
                winText = "Acquistato: \(item.name)!"
            case "Boost Moltiplicatore":
                hasMultiplierBoost = true
                winText = "Acquistato: \(item.name)!"
            case "Assicurazione Vincita":
                hasBigWinInsurance = true
                winText = "Acquistato: \(item.name)!"
            case "Jackpot Garantito":
                hasGuaranteedJackpot = true
                winText = "Acquistato: \(item.name)!"
            case "Giri Gratuiti":
                hasFreeSpins = true
                freeSpinsRemaining = 5
                winText = "Acquistato: \(item.name)!"
            case "Booster Jackpot":
                hasJackpotBooster = true
                winText = "Acquistato: \(item.name)!"
            case "Crediti Doppi":
                hasDoubleCredits = true
                doubleCreditSpinsRemaining = 5
                winText = "Acquistato: \(item.name)!"
                
            default:
                winText = "Acquistato: \(item.name)!"
            }
        }
    }
    
    func checkWin() {
        let symbol1 = numbers[0]
        let symbol2 = numbers[1]
        let symbol3 = numbers[2]
        
        var winAmount = 0
        
        if symbols[symbol1] == "7️⃣" && symbols[symbol2] == "7️⃣" && symbols[symbol3] == "7️⃣" {
            winAmount = betAmount * 5000
            credits += winAmount
            winText = "MEGA JACKPOT!!! Hai vinto €\(winAmount)!"
        }
        else if symbol1 == symbol2 && symbol2 == symbol3 {
            let multiplier = hasMultiplierBoost ? 15 : 10
            winAmount = betAmount * multiplier
            credits += winAmount
            winText = "Jackpot! Hai vinto €\(winAmount)!"
        }
        else if symbol1 == symbol2 || symbol2 == symbol3 || symbol1 == symbol3 {
            let multiplier = hasMultiplierBoost ? 3 : 2
            winAmount = betAmount * multiplier
            credits += winAmount
            winText = "Hai vinto €\(winAmount)!"
        }
        else if hasBigWinInsurance {
            winAmount = 5
            credits += winAmount
            winText = "Assicurazione: Hai vinto €\(winAmount)!"
        }
        else {
            winText = "Ritenta, sarai più fortunato!"
        }
        
        if hasDoubleCredits && doubleCreditSpinsRemaining > 0 && winAmount > 0 {
            let originalWin = winAmount
            winAmount *= 2
            credits += originalWin
            winText = winText.replacingOccurrences(of: "€\(originalWin)", with: "€\(winAmount)") + " (CREDITI DOPPI!)"
        }
    }
}

struct BetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct SpinButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 200)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

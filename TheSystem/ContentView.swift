import SwiftUI

struct ContentView: View {
    @EnvironmentObject var xpManager: XPManager
    @State private var showResetConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Title and Logo
                VStack(spacing: 12) {
                    Text("Money is Power")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primary)

                    Image("faux")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                }


                // Life Level Section
                let lifeXP = xpManager.globalLifeXP
                let lifeLevel = xpManager.lifeLevel(for: lifeXP)
                let lifeXpNeeded = xpManager.lifeXpNeeded(for: lifeLevel)
                let lifeXPInLevel = lifeXP - xpManager.totalLifeXPForLevel(lifeLevel)

                Text("LIFE LEVEL: \(lifeLevel)")
                    .font(.system(size: 30, weight: .bold))

                ProgressView(value: Double(lifeXPInLevel), total: Double(lifeXpNeeded))
                    .progressViewStyle(.linear)
                    .accentColor(.blue)
                    .frame(height: 10)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.95)

                Text("XP: \(lifeXPInLevel) / \(lifeXpNeeded)")
                    .font(.system(size: 18))

                Divider()

                // Core Categories
                ForEach(Category.allCases.filter { $0 != .life }, id: \.self) { category in
                    let xp = xpManager.xp[category] ?? 0
                    let level = xpManager.level(for: xp)
                    let xpNeeded = xpManager.xpNeeded(for: level)
                    let xpInLevel = xp - xpManager.totalXPForLevel(level)

                    VStack(spacing: 10) {
                        Text("\(emoji(for: category)) \(category.rawValue): Level \(level)")
                            .font(.system(size: 24, weight: .semibold))

                        ProgressView(value: Double(xpInLevel), total: Double(xpNeeded))
                            .progressViewStyle(.linear)
                            .accentColor(.blue)
                            .frame(height: 8)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.95)

                        Text("XP: \(xpInLevel) / \(xpNeeded)")
                            .font(.system(size: 16))

                        NavigationLink(destination: CategoryDetailView(category: category)) {
                            Text("View")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.vertical, 12)
                }

                Divider()

                // Vel'krax
                VStack(spacing: 12) {
                    Text("Vel’krax HP: \(xpManager.globalVelkraxHP)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.red)

                    ProgressView(value: Double(xpManager.globalVelkraxHP), total: 90)
                        .progressViewStyle(.linear)
                        .accentColor(.red)
                        .frame(height: 10)

                    Image("velkrax")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(.top, 10)
                }

                // Reset Button
                Button(action: { showResetConfirmation = true }) {
                    Text("Reset All Levels")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.top, 24)
                .alert("Confirm Reset", isPresented: $showResetConfirmation) {
                    Button("Reset", role: .destructive) {
                        xpManager.resetAllLevels()
                        xpManager.objectWillChange.send()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to reset all levels? This action cannot be undone.")
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            xpManager.objectWillChange.send()
        }
    }

    func emoji(for category: Category) -> String {
        switch category {
        case .health: return "💪"
        case .wisdom: return "📘"
        case .power: return "🛠️"
        case .aura: return "🌌"
        case .life: return "🌟"
        }
    }
}


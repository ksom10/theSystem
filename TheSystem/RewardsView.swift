import SwiftUI

struct RewardsView: View {
    @EnvironmentObject var xpManager: XPManager

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text("Rewards")
                    .font(.largeTitle)
                    .bold()

                ForEach(rewards, id: \.title) { reward in
                    rewardItem(unlocked: reward.isUnlocked,
                               title: reward.title,
                               condition: reward.condition)
                        .frame(width: UIScreen.main.bounds.width * 0.95) // 🔥 Fixed width
                }
            }
            .padding()
        }
    }

    func rewardItem(unlocked: Bool, title: String, condition: String) -> some View {
        HStack {
            if unlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                    .font(.title2)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(condition)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer() // 🔥 Ensures content aligns and fills space
        }
        .padding()
        .background(unlocked ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    func meetsCalorieTrainingGoal() -> Bool {
        let healthXP = xpManager.xp[.health] ?? 0
        let healthLevel = xpManager.level(for: healthXP)
        return healthLevel >= 4
    }

    var rewards: [Reward] {
        [
            Reward(
                isUnlocked: meetsCalorieTrainingGoal(),
                title: "🥃 Fancy Bottle of Liquor",
                condition: "5x Gym + 4000 Cal (Mon–Fri)"
            ),
            Reward(
                isUnlocked: (xpManager.level(for: xpManager.xp[.wisdom] ?? 0) >= 3),
                title: "📚 Book Purchase",
                condition: "Level 3 in Wisdom"
            ),
            Reward(
                isUnlocked: (xpManager.level(for: xpManager.xp[.power] ?? 0) >= 2),
                title: "🛠️ Power Tool",
                condition: "Level 2 in Power"
            ),
            Reward(
                isUnlocked: (xpManager.level(for: xpManager.xp[.aura] ?? 0) >= 3),
                title: "🌌 Aura Buff",
                condition: "Level 3 in Aura"
            )
        ]
    }
}

struct Reward {
    let isUnlocked: Bool
    let title: String
    let condition: String
}


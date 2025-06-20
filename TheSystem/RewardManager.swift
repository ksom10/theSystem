import SwiftUI

struct RewardManager: View {
    @EnvironmentObject var xpManager: XPManager

    var body: some View {
        VStack(spacing: 20) {
            RewardItem(
                locked: xpManager.globalVelkraxHP > 0,
                title: "Vel'krax Slayer",
                requirement: "Defeat Vel'krax"
            )
            RewardItem(
                locked: xpManager.streaks[.aura, default: 0] < 30,
                title: "Charm Questline",
                requirement: "30-Day Porn-Free Streak"
            )
            // Add more rewards as needed
        }
    }
}

struct RewardItem: View {
    let locked: Bool
    let title: String
    let requirement: String

    var body: some View {
        HStack {
            Image(systemName: locked ? "lock.fill" : "lock.open.fill")
                .foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(requirement).font(.caption).foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}


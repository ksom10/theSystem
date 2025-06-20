import SwiftUI

struct QuestLogView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Current Objectives")
                    .font(.title2)
                    .bold()

                Text("• Reach 4000–5000 calories per day (5x/week for reward)")
                Text("• Train 5x per week (Mon–Fri streak = fancy bottle unlock)")
                Text("• Stay porn-free to lower Vel’krax HP")
                Text("• Reach Level 2 in Power to unlock Web Dev Buff")
                Text("• Reach Aura Level 2 to unlock Charm Questline")
            }
            .padding()
            .navigationTitle("Quests")
        }
    }
}


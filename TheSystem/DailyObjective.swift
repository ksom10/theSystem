import SwiftUI

struct DailyObjective: Identifiable {
    let id = UUID()
    let title: String
    let xpReward: Int
    let category: Category
    var completed: Bool = false
}

struct DailyObjectiveList: View {
    @EnvironmentObject var xpManager: XPManager
    let category: Category

    @State private var objectives: [DailyObjective] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(category.rawValue) Objectives")
                .font(.title2)
                .bold()

            ForEach($objectives) { $objective in
                HStack {
                    Button(action: {
                        if !objective.completed {
                            xpManager.gainXP(category: objective.category, amount: objective.xpReward)

                            if objective.category == .aura && objective.title == "Porn-Free Day" {
                                xpManager.tickAuraStreak()
                            }

                            objective.completed = true
                        }
                    }) {
                        HStack {
                            Image(systemName: objective.completed ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(objective.completed ? .green : .gray)
                            Text(objective.title)
                        }
                    }
                    .disabled(objective.completed)
                }
            }
        }
        .padding()
        .onAppear {
            loadObjectives()
        }
    }

    private func loadObjectives() {
        switch category {
        case .health:
            objectives = [
                DailyObjective(title: "Gym Session", xpReward: 5, category: .health),
                DailyObjective(title: "Ate 4000 Calories", xpReward: 3, category: .health)
            ]
        case .wisdom:
            objectives = [
                DailyObjective(title: "Meditated", xpReward: 2, category: .wisdom),
                DailyObjective(title: "Read Book / Journaling", xpReward: 3, category: .wisdom)
            ]
        case .power:
            objectives = [
                DailyObjective(title: "Worked Shift", xpReward: 3, category: .power),
                DailyObjective(title: "Coded / Website Work", xpReward: 5, category: .power)
            ]
        case .aura:
            objectives = [
                DailyObjective(title: "Porn-Free Day", xpReward: 1, category: .aura)
            ]
        case .life:
            objectives = [] // Life has no daily objectives
        }
    }
}


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
          NavigationView { ContentView() }
            .tabItem { Label("Home", systemImage: "house.fill") }

          NavigationView { QuestLogView() }
            .tabItem { Label("Quests", systemImage: "target") }

          NavigationView { RewardsView() }
            .tabItem { Label("Rewards", systemImage: "gift.fill") }

          NavigationView { BossesView() }
            .tabItem { Label("Bosses", systemImage: "shield.lefthalf.fill") }
        }

    }
}


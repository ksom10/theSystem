import SwiftUI
import CoreData

class XPManager: ObservableObject {
    @Published var xp: [Category: Int] = [:]
    @Published var streaks: [Category: Int] = [.aura: 0]
    @Published var globalVelkraxHP: Int = 90
    @Published var globalLifeXP: Int = 0
    @Published var ladyIndica: LadyIndica?

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        loadXP()
        loadGlobalStats()
        fetchOrCreateLadyIndica()
    }

    // MARK: - XP Persistence
    private func loadXP() {
        let categories = Category.allCases.filter { $0 != .life }
        for category in categories {
            let key = "xp_\(category.rawValue)"
            let value = UserDefaults.standard.integer(forKey: key)
            xp[category] = value
        }
    }

    private func saveXP(for category: Category) {
        let key = "xp_\(category.rawValue)"
        UserDefaults.standard.set(xp[category, default: 0], forKey: key)
    }

    // MARK: - Global Stats
    private func loadGlobalStats() {
        globalVelkraxHP = UserDefaults.standard.integer(forKey: "velkrax_hp")
        if globalVelkraxHP == 0 {
            globalVelkraxHP = 90
        }

        globalLifeXP = UserDefaults.standard.integer(forKey: "life_xp")
    }

    private func saveGlobalStats() {
        UserDefaults.standard.set(globalVelkraxHP, forKey: "velkrax_hp")
        UserDefaults.standard.set(globalLifeXP, forKey: "life_xp")
        do {
            try viewContext.save()
        } catch {
            print("❌ Failed to save Core Data context:", error)
        }
    }

    // MARK: - Boss: Lady Indica
    private func fetchOrCreateLadyIndica() {
        let request: NSFetchRequest<LadyIndica> = LadyIndica.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            if let existing = results.first {
                ladyIndica = existing
            } else {
                let newLady = LadyIndica(context: viewContext)
                newLady.hp = 85
                try viewContext.save()
                ladyIndica = newLady
            }
        } catch {
            print("❌ Failed to fetch/create LadyIndica:", error)
        }
    }

    func damageLadyIndica(_ amount: Int = 1) {
        guard let lady = ladyIndica else { return }
        lady.hp = max(lady.hp - Int32(amount), 0)
        saveGlobalStats()
    }

    func restoreLadyIndica() {
        guard let lady = ladyIndica else { return }
        lady.hp = 85
        saveGlobalStats()
    }

    // MARK: - Boss: Vel'krax
    func damageVelkrax() {
        globalVelkraxHP = max(globalVelkraxHP - 1, 0)
        saveGlobalStats()
    }

    func restoreVelkrax() {
        globalVelkraxHP = 90
        saveGlobalStats()
    }

    // MARK: - XP Mechanics
    func gainXP(category: Category, amount: Int) {
        xp[category, default: 0] += amount
        saveXP(for: category)
        updateLifeXP()
        objectWillChange.send() // Trigger UI refresh
    }

    private func updateLifeXP() {
        globalLifeXP = xp.values.reduce(0, +)
        saveGlobalStats()
    }

    // MARK: - Streak Mechanics
    func tickAuraStreak() {
        streaks[.aura, default: 0] += 1
    }

    func resetAuraStreak() {
        streaks[.aura] = 0
    }

    // MARK: - Leveling Logic
    func level(for xp: Int) -> Int {
        var level = 1
        var remainingXP = xp
        while remainingXP >= xpNeeded(for: level) {
            remainingXP -= xpNeeded(for: level)
            level += 1
        }
        return level
    }

    func xpNeeded(for level: Int) -> Int {
        return max(10, level * level * 5)
    }

    func totalXPForLevel(_ level: Int) -> Int {
        guard level > 1 else { return 0 }
        var total = 0
        for i in 1..<level {
            total += xpNeeded(for: i)
        }
        return total
    }

    func lifeLevel(for lifeXP: Int) -> Int {
        return level(for: lifeXP)
    }

    func lifeXpNeeded(for level: Int) -> Int {
        // Slightly higher multiplier for life-level scaling (1.4x)
        return max(10, Int(Double(level * level * 5) * 1.4))
    }


    func totalLifeXPForLevel(_ level: Int) -> Int {
        return totalXPForLevel(level)
    }

    // MARK: - Reset System
    func resetAllLevels() {
        for category in Category.allCases {
            xp[category] = 0
            saveXP(for: category)
        }

        globalVelkraxHP = 90
        globalLifeXP = 0
        resetAuraStreak()
        restoreLadyIndica()
        saveGlobalStats()
    }
}


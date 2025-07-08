import SwiftUI
import CoreData

class XPManager: ObservableObject {
    @Published var xp: [Category: Int] = [:]
    @Published var streaks: [Category: Int] = [.aura: 0]
    @Published var globalVelkraxHP: Int = 90
    @Published var globalLifeXP: Int = 0
    @Published var ladyIndica: LadyIndica?
    @Published var machia: Machia?
    @Published var nightpour: Nightpour?
    @Published var neverest: Neverest?



    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        loadXP()
        loadGlobalStats()
        fetchOrCreateLadyIndica()
        fetchOrCreateMachia()
        fetchOrCreateNightpour()
        fetchOrCreateNeverest()

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
    
    private func fetchOrCreateNightpour() {
        let request: NSFetchRequest<Nightpour> = Nightpour.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            if let existing = results.first {
                nightpour = existing
            } else {
                let newNightpour = Nightpour(context: viewContext)
                newNightpour.hp = 30
                try viewContext.save()
                nightpour = newNightpour
            }
        } catch {
            print("❌ Failed to fetch/create Nightpour:", error)
        }
    }

    func damageNightpour(_ amount: Int = 1) {
        guard let nightpour = nightpour else { return }
        nightpour.hp = max(nightpour.hp - Int32(amount), 0)
        saveGlobalStats()
    }

    func restoreNightpour() {
        guard let nightpour = nightpour else { return }
        nightpour.hp = 70
        saveGlobalStats()
    }
    
    private func fetchOrCreateNeverest() {
        let request: NSFetchRequest<Neverest> = Neverest.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            if let existing = results.first {
                neverest = existing
            } else {
                let newNeverest = Neverest(context: viewContext)
                newNeverest.hp = 500
                try viewContext.save()
                neverest = newNeverest
            }
        } catch {
            print("❌ Failed to fetch/create Neverest:", error)
        }
    }
    
    func damageNeverest(_ amount: Int = 1) {
        guard let neverest = neverest else { return }
        neverest.hp = max(neverest.hp - Int32(amount), 0)
        saveGlobalStats()
    }

    func restoreNeverest() {
        guard let neverest = neverest else { return }
        neverest.hp = 500
        saveGlobalStats()
    }



    // MARK: - Ally: Machia
    private func fetchOrCreateMachia() {
        let request: NSFetchRequest<Machia> = Machia.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            if let existing = results.first {
                machia = existing
            } else {
                let newMachia = Machia(context: viewContext)
                newMachia.hp = 0
                try viewContext.save()
                machia = newMachia
            }
        } catch {
            print("❌ Failed to fetch/create Machia:", error)
        }
    }

    func chargeMachia() {
        guard let machia = machia else { return }
        if machia.hp < 5 {
            machia.hp += 1
            saveGlobalStats()
        }
    }

    func resetMachia() {
        machia?.hp = 0
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
        return 20 * level
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
        return 30 * level
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
        resetMachia()
        saveGlobalStats()
    }
}


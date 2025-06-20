import Foundation

enum Category: String, CaseIterable, Identifiable {
    case health = "Health"
    case wisdom = "Wisdom"
    case power = "Power"
    case aura = "Aura"
    case life = "Life" // ✅ Add Life category here

    var id: String { rawValue }
}


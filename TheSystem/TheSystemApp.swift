import SwiftUI

@main
struct TheSystemApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var xpManager = XPManager() // <- create it once at root level

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(xpManager) // <- inject here
                .font(.custom("Sixtyfour-Regular", size: 20)) // <- apply global font
        }
    }
}


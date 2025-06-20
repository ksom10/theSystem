import SwiftUI

struct BossesView: View {
    @EnvironmentObject var xpManager: XPManager

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {

                // MARK: - Vel’krax
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

                Divider()

                // MARK: - Lady Indica
                if let lady = xpManager.ladyIndica {
                    VStack(spacing: 12) {
                        Text("Lady Indica HP: \(lady.hp)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.green)

                        ProgressView(value: Double(lady.hp), total: 85)
                            .progressViewStyle(.linear)
                            .accentColor(.green)
                            .frame(height: 10)

                        Image("ladyindica")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding(.top, 10)
                    }
                } else {
                    Text("Loading Lady Indica...")
                        .font(.headline)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Bosses")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


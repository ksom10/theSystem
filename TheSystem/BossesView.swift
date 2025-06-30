import SwiftUI

struct BossesView: View {
    @EnvironmentObject var xpManager: XPManager

    @State private var showVelkraxResetAlert = false
    @State private var showIndicaResetAlert = false
    @State private var showMachiaResetAlert = false

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
                        .frame(width: 320, height: 200)
                        .padding(.top, 10)

                    Button("Reset Vel’krax") {
                        showVelkraxResetAlert = true
                    }
                    .font(.caption)
                    .padding(8)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .alert("Reset Vel’krax?", isPresented: $showVelkraxResetAlert) {
                        Button("Confirm", role: .destructive) {
                            xpManager.restoreVelkrax()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
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
                            .frame(width: 380, height: 240)
                            .padding(.top, 10)

                        Button("Reset Lady Indica") {
                            showIndicaResetAlert = true
                        }
                        .font(.caption)
                        .padding(8)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .alert("Reset Lady Indica?", isPresented: $showIndicaResetAlert) {
                            Button("Confirm", role: .destructive) {
                                xpManager.restoreLadyIndica()
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                } else {
                    Text("Loading Lady Indica...")
                        .font(.headline)
                }

                Divider()

                // MARK: - Machia (Ally)
                if let machia = xpManager.machia {
                    VStack(spacing: 12) {
                        Text("Machia Charge: \(machia.hp)/5")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.blue)

                        ProgressView(value: Double(machia.hp), total: 5)
                            .progressViewStyle(.linear)
                            .accentColor(.blue)
                            .frame(height: 10)

                        ZStack {
                            Image("machia")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 380, height: 240)

                            if machia.hp < 5 {
                                Color.black.opacity(0.5)
                                    .frame(width: 380, height: 240)

                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 10)

                        Button("Reset Machia") {
                            showMachiaResetAlert = true
                        }
                        .font(.caption)
                        .padding(8)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .alert("Reset Machia?", isPresented: $showMachiaResetAlert) {
                            Button("Confirm", role: .destructive) {
                                xpManager.resetMachia()
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                } else {
                    Text("Loading Machia...")
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


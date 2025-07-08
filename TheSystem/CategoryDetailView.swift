import SwiftUI
import CoreData

struct CategoryDetailView: View {
    @EnvironmentObject var xpManager: XPManager
    @Environment(\.managedObjectContext) private var viewContext

    let category: Category

    @State private var newTaskTitle: String = ""
    @State private var newTaskXP: String = ""
    @State private var showTaskForm = false
    @State private var fetchedObjectives: [ObjectiveEntity] = []

    var body: some View {
        let xp = xpManager.xp[category] ?? 0
        let level = xpManager.level(for: xp)
        let xpNeeded = xpManager.xpNeeded(for: level)
        let xpInCurrentLevel = xp - xpManager.totalXPForLevel(level)

        VStack(spacing: 24) {
            Text("\(category.rawValue) Objectives")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 8) {
                Text("Level \(level)")
                    .font(.title2)
                    .bold()

                ProgressView(value: Double(xpInCurrentLevel), total: Double(xpNeeded))
                    .progressViewStyle(.linear)
                    .accentColor(.blue)
                    .frame(height: 10)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.95)

                Text("XP: \(xpInCurrentLevel) / \(xpNeeded)")
                    .font(.caption)
            }

            Divider()

            List {
                ForEach(fetchedObjectives, id: \.self) { obj in
                    Button(action: {
                        DispatchQueue.main.async {
                            xpManager.gainXP(category: category, amount: Int(obj.xpReward))

                            if category == .aura && obj.title == "Porn-Free Day" {
                                xpManager.tickAuraStreak()
                                xpManager.damageVelkrax()
                            }

                            if category == .wisdom && obj.title == "Weed-Free Day" {
                                xpManager.damageLadyIndica()
                            }

                            if category == .power && obj.title == "Complete Website" {
                                xpManager.chargeMachia()
                            }
                            
                            if category == .health && obj.title == "Liquor-Free Day" {
                                        xpManager.damageNightpour()
                            }
                            
                            if category == .power && obj.title ==
                                "Code" {
                                xpManager.damageNeverest()
                            }
                        }
                    }) {
                        HStack {
                            Text(obj.title ?? "Untitled")
                                .font(.headline)
                            Spacer()
                            Text("+\(obj.xpReward) XP")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .onDelete(perform: deleteObjective)
            }
            .listStyle(PlainListStyle())

            Button(action: {
                showTaskForm.toggle()
            }) {
                Text("+ Add Task")
                    .font(.headline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            if showTaskForm {
                VStack(spacing: 10) {
                    TextField("Task Title", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("XP Reward", text: $newTaskXP)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onChange(of: newTaskXP) { newValue in
                            newTaskXP = newValue.filter { $0.isNumber }
                        }

                    Button("Add") {
                        guard !newTaskTitle.isEmpty, let xpValue = Int(newTaskXP) else { return }
                        let newObjective = ObjectiveEntity(context: viewContext)
                        newObjective.title = newTaskTitle
                        newObjective.xpReward = Int32(xpValue)
                        newObjective.category = category.rawValue
                        newObjective.isCompleted = false
                        do {
                            try viewContext.save()
                            fetchObjectives()
                            newTaskTitle = ""
                            newTaskXP = ""
                            showTaskForm = false
                        } catch {
                            print("❌ Failed to save new objective: \(error)")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .onAppear(perform: fetchObjectives)
    }

    private func fetchObjectives() {
        let request: NSFetchRequest<ObjectiveEntity> = ObjectiveEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        do {
            fetchedObjectives = try viewContext.fetch(request)
        } catch {
            print("❌ Failed to fetch objectives: \(error)")
        }
    }

    private func deleteObjective(at offsets: IndexSet) {
        for index in offsets {
            let obj = fetchedObjectives[index]
            viewContext.delete(obj)
        }
        do {
            try viewContext.save()
            fetchObjectives()
        } catch {
            print("❌ Failed to delete objective: \(error)")
        }
    }
}


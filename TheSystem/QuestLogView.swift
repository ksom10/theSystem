import SwiftUI
import CoreData

struct QuestLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var xpManager: XPManager

    @State private var quests: [QuestEntity] = []
    @State private var newQuestTitle: String = ""
    @State private var newQuestXP: String = ""
    @State private var selectedQuestCategory: Category = .health
    @State private var showQuestForm: Bool = false
    @State private var questToConfirm: QuestEntity?
    @State private var showCompletionDialog: Bool = false
    @State private var questToDelete: QuestEntity?
    @State private var showDeletionDialog: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if showQuestForm {
                        questFormSection
                    }

                    activeQuestsSection

                    Divider()

                    completedQuestsSection
                }
                .padding()
            }
            .navigationTitle("Quests")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showQuestForm.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear(perform: fetchQuests)
            .alert("Confirm Quest Completion", isPresented: $showCompletionDialog, presenting: questToConfirm) { quest in
                Button("Approve") {
                    completeQuest(quest)
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("Are you sure you want to complete this quest?")
            }
            .alert("Delete Quest", isPresented: $showDeletionDialog, presenting: questToDelete) { quest in
                Button("Delete", role: .destructive) {
                    deleteQuest(quest)
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("This action cannot be undone.")
            }
        }
    }

    // MARK: - Form Section
    private var questFormSection: some View {
        VStack(spacing: 10) {
            TextField("Quest Title", text: $newQuestTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("XP", text: $newQuestXP)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .onChange(of: newQuestXP) { newValue in
                    newQuestXP = newValue.filter { $0.isNumber }
                }

            HStack {
                ForEach(Category.allCases.filter { $0 != .life }, id: \.self) { cat in
                    Button(action: {
                        selectedQuestCategory = cat
                    }) {
                        Text(cat.rawValue.capitalized)
                            .font(.footnote)
                            .foregroundColor(selectedQuestCategory == cat ? .white : .black)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(selectedQuestCategory == cat ? Color.blue : Color.gray.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
            }

            Button("Add Quest") {
                addQuest()
                showQuestForm = false
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: - Active Quests
    private var activeQuestsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Quests")
                .font(.title2)
                .bold()

            ForEach(quests.filter { !$0.isCompleted }, id: \.self) { quest in
                VStack(spacing: 6) {
                    Button(action: {
                        questToConfirm = quest
                        showCompletionDialog = true
                    }) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(quest.title ?? "Untitled")
                                Spacer()
                                Text("+\(quest.xpReward) XP")
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Color.blue)
                                    .cornerRadius(6)
                            }

                            Text("Category: \(quest.category ?? "Unknown")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            questToDelete = quest
                            showDeletionDialog = true
                        } label: {
                            Label("Delete Quest", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Completed Quests
    private var completedQuestsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Completed Quests")
                .font(.title2)
                .bold()

            ForEach(quests.filter { $0.isCompleted }, id: \.self) { quest in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(quest.title ?? "Untitled")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }

                    if let date = quest.dateCompleted {
                        Text("Completed on: \(formatted(date))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Text("Category: \(quest.category ?? "Unknown")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
        }
    }

    // MARK: - Helpers
    private func fetchQuests() {
        let request: NSFetchRequest<QuestEntity> = QuestEntity.fetchRequest()
        do {
            quests = try viewContext.fetch(request)
        } catch {
            print("❌ Failed to fetch quests: \(error)")
        }
    }

    private func addQuest() {
        guard !newQuestTitle.isEmpty,
              let xp = Int(newQuestXP) else { return }

        let newQuest = QuestEntity(context: viewContext)
        newQuest.title = newQuestTitle
        newQuest.xpReward = Int32(xp)
        newQuest.isCompleted = false
        newQuest.category = selectedQuestCategory.rawValue
        newQuest.dateCompleted = nil

        do {
            try viewContext.save()
            fetchQuests()
            newQuestTitle = ""
            newQuestXP = ""
            selectedQuestCategory = .health
        } catch {
            print("❌ Failed to add quest: \(error)")
        }
    }

    private func completeQuest(_ quest: QuestEntity) {
        guard !quest.isCompleted else { return }
        quest.isCompleted = true
        quest.dateCompleted = Date()

        if let raw = quest.category, let cat = Category(rawValue: raw) {
            xpManager.gainXP(category: cat, amount: Int(quest.xpReward))
        }

        do {
            try viewContext.save()
            fetchQuests()
        } catch {
            print("❌ Failed to complete quest: \(error)")
        }
    }

    private func deleteQuest(_ quest: QuestEntity) {
        viewContext.delete(quest)
        do {
            try viewContext.save()
            fetchQuests()
        } catch {
            print("❌ Failed to delete quest: \(error)")
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


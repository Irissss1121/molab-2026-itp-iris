import CoreLocation
import SwiftData
import SwiftUI

// A new entry carries the captured coordinate. Opening a saved pin also supplies its Memory.
struct MemoryEntry: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var memory: Memory?
}

struct MemoryEditor: View {
    let entry: MemoryEntry
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var mood: String
    @State private var note: String
    @State private var showSaveError = false

    private let moods = ["Happy", "Calm", "Excited", "Sad", "Stressed", "Tired"]

    init(entry: MemoryEntry, onSave: @escaping () -> Void) {
        self.entry = entry
        self.onSave = onSave
        // Copy the saved values into a draft so Cancel can discard edits and keep the original memory.
        _mood = State(initialValue: entry.memory?.mood ?? "")
        _note = State(initialValue: entry.memory?.note ?? "")
    }

    private var trimmedNote: String {
        note.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Mood", selection: $mood) {
                        Text("No mood").tag("")
                        ForEach(moods, id: \.self) { Text($0).tag($0) }
                    }
                    TextField("What do you want to remember?", text: $note, axis: .vertical)
                        .lineLimit(3...8)
                        .accessibilityLabel("Note")
                } footer: {
                    if mood.isEmpty && trimmedNote.isEmpty {
                        Text("Choose a mood or write a note to save.")
                    }
                }

                Section("Place and time") {
                    LabeledContent("Location") {
                        Text("\(entry.coordinate.latitude, specifier: "%.4f"), \(entry.coordinate.longitude, specifier: "%.4f")")
                    }
                    if let memory = entry.memory {
                        LabeledContent("Saved", value: memory.date.formatted(date: .abbreviated, time: .shortened))
                    }
                }
            }
            .navigationTitle(entry.memory == nil ? "Add Memory" : "Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        // Save needs a mood or a note. Spaces and line breaks alone count as an empty note.
                        .disabled(mood.isEmpty && trimmedNote.isEmpty)
                }
            }
            .alert("Couldn’t save this memory", isPresented: $showSaveError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your draft is still here. Try saving again.")
            }
        }
    }

    private func save() {
        // Reuse the selected memory when editing. Create a record only for a new pin.
        let memory = entry.memory ?? Memory(at: entry.coordinate)
        memory.mood = mood
        memory.note = trimmedNote
        if entry.memory == nil { context.insert(memory) }

        do {
            try context.save()
            onSave()
            dismiss()
        } catch {
            // Undo the failed storage changes and keep the draft on screen so the user can retry.
            context.rollback()
            showSaveError = true
        }
    }
}

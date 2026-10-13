import SwiftUI
import AVFoundation

struct ContentView: View {

    @AppStorage("selectedMood") private var selectedMood = "😊"

    // Mood history in memory
    @State private var moodHistory: [String] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {

                Text("How do you feel?")
                    .font(.largeTitle)
                    .bold()

                HStack(spacing: 25) {

                    Button("😊") {
                        selectedMood = "😊"
                    }

                    Button("😴") {
                        selectedMood = "😴"
                    }

                    Button("😌") {
                        selectedMood = "😌"
                    }
                }
                .font(.system(size: 50))

                Text("Selected: \(selectedMood)")

                // Add the selected mood to the history
                Button("Add Mood") {
                    moodHistory.append(selectedMood)
                }
                .buttonStyle(.bordered)

                Text("Mood History")
                    .font(.headline)

                // Display all moods in the array
                Text(moodHistory.joined(separator: "  "))
                    .font(.system(size: 35))

                HStack {
                    // Save the array as a JSON file
                    Button("Save") {
                        saveHistory()
                    }

                    // Load the array from the JSON file
                    Button("Restore") {
                        restoreHistory()
                    }

                    // Only clears the current array
                    Button("Clear") {
                        moodHistory.removeAll()
                    }
                }
                .buttonStyle(.bordered)

                NavigationLink("Continue") {
                    SoundView(selectedMood: selectedMood)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }


    // Save moodHistory as moodHistory.json
    func saveHistory() {

        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("moodHistory.json")

        do {
            let data = try JSONEncoder().encode(moodHistory)
            try data.write(to: fileURL)

            print("Saved:", moodHistory)
            print("File:", fileURL)

        } catch {
            print("Save error:", error)
        }
    }


    // Restore moodHistory from moodHistory.json
    func restoreHistory() {

        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("moodHistory.json")

        do {
            let data = try Data(contentsOf: fileURL)

            moodHistory = try JSONDecoder()
                .decode([String].self, from: data)

            print("Restored:", moodHistory)

        } catch {
            print("Restore error:", error)
        }
    }
}


struct SoundView: View {

    let selectedMood: String

    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack(spacing: 30) {

            Text("Your Mood")
                .font(.largeTitle)
                .bold()

            Text(selectedMood)
                .font(.system(size: 80))

            Button("Play Sound") {
                playSound()
            }
            .buttonStyle(.borderedProminent)

            Button("Stop") {
                audioPlayer?.stop()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    func playSound() {

        var soundName = "happy"

        if selectedMood == "😴" {
            soundName = "sleep"
        } else if selectedMood == "😌" {
            soundName = "calm"
        }

        guard let url = Bundle.main.url(
            forResource: soundName,
            withExtension: "mp3"
        ) else {
            print("\(soundName).mp3 not found")
            return
        }

        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
}


#Preview {
    ContentView()
}

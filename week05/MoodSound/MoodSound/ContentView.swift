import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @AppStorage("selectedMood") private var selectedMood = "😊"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
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
                
                NavigationLink("Continue") {
                    SoundView(selectedMood: selectedMood)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
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

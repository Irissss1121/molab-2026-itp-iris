import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Random Animal")
                    .font(.system(size: 36))
                
                NavigationLink("Start") {
                    AnimalView()
                }
                .font(.system(size: 24))
            }
            .padding()
        }
    }
}


struct AnimalView: View {
    
    let animals = ["dog.fill", "cat.fill", "bird.fill", "fish.fill"]
    
    let decorations = ["star.fill", "heart.fill", "leaf.fill", "sparkles"]
    
    let colors: [Color] = [.blue, .green, .orange, .purple]
    
    @State var currentAnimal = "dog.fill"
    @State var currentDecoration = "star.fill"
    @State var currentColor = Color.blue
    
    var body: some View {
        VStack(spacing: 30) {
            
            ZStack {
                
                Circle()
                    .fill(currentColor.opacity(0.25))
                    .frame(width: 230, height: 230)
                
                Image(systemName: currentAnimal)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                
                Image(systemName: currentDecoration)
                    .font(.system(size: 35))
                    .offset(x: 75, y: -75)
            }
            
            Button("Randomize") {
                
                let animalNumber = Int.random(in: 0..<animals.count)
                let decorationNumber = Int.random(in: 0..<decorations.count)
                let colorNumber = Int.random(in: 0..<colors.count)
                
                currentAnimal = animals[animalNumber]
                currentDecoration = decorations[decorationNumber]
                currentColor = colors[colorNumber]
            }
            .font(.system(size: 24))
        }
        .padding()
    }
}


#Preview {
    ContentView()
}

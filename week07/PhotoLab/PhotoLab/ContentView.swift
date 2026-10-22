import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var selectedItem1: PhotosPickerItem?
    @State private var selectedItem2: PhotosPickerItem?
    
    @State private var image1: UIImage?
    @State private var image2: UIImage?
    
    @State private var opacity = 0.5
    @State private var blendMode: BlendMode = .normal
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Photo Blend")
                    .font(.largeTitle)
                    .bold()
                
                // Blended preview
                ZStack {
                    
                    if let image1 {
                        Image(uiImage: image1)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    if let image2 {
                        Image(uiImage: image2)
                            .resizable()
                            .scaledToFit()
                            .opacity(opacity)
                            .blendMode(blendMode)
                    }
                    
                    if image1 == nil && image2 == nil {
                        ContentUnavailableView(
                            "No Photos",
                            systemImage: "photo.on.rectangle.angled",
                            description: Text("Choose two photos to blend")
                        )
                    }
                }
                .frame(maxHeight: 420)
                
                // Photo picker buttons
                HStack {
                    
                    PhotosPicker(selection: $selectedItem1) {
                        Label("Photo 1", systemImage: "photo")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    PhotosPicker(selection: $selectedItem2) {
                        Label("Photo 2", systemImage: "photo")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                // Blend amount
                VStack {
                    Text("Blend Amount")
                        .font(.headline)
                    
                    Slider(value: $opacity, in: 0...1)
                }
                
                // Blend mode buttons
                HStack {
                    
                    Button("Normal") {
                        blendMode = .normal
                    }
                    
                    Button("Multiply") {
                        blendMode = .multiply
                    }
                    
                    Button("Screen") {
                        blendMode = .screen
                    }
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .padding()
            .onChange(of: selectedItem1) {
                loadImage1()
            }
            .onChange(of: selectedItem2) {
                loadImage2()
            }
        }
    }
    
    func loadImage1() {
        Task {
            guard let data = try? await selectedItem1?
                .loadTransferable(type: Data.self) else {
                return
            }
            
            image1 = UIImage(data: data)
        }
    }
    
    func loadImage2() {
        Task {
            guard let data = try? await selectedItem2?
                .loadTransferable(type: Data.self) else {
                return
            }
            
            image2 = UIImage(data: data)
        }
    }
}

#Preview {
    ContentView()
}

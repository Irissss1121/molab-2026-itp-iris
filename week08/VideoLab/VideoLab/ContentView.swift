import SwiftUI
import PhotosUI
import AVKit
import CoreTransferable
import UniformTypeIdentifiers


// A video file selected from PhotosPicker
struct Movie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {

        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)

        } importing: { received in

            // Copy the selected video into a temporary file
            let copyURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(received.file.pathExtension)

            try FileManager.default.copyItem(
                at: received.file,
                to: copyURL
            )

            return Movie(url: copyURL)
        }
    }
}


struct ContentView: View {

    // Video selected from photo library
    @State private var selectedItem: PhotosPickerItem?

    // Video player
    @State private var player: AVPlayer?

    @State private var isLoading = false

    // Current playback speed
    @State private var playbackSpeed = 1.0

    // Current visual style
    @State private var selectedStyle = "Normal"


    var body: some View {

        NavigationStack {

            VStack(spacing: 20) {

                Text("Video Lab")
                    .font(.largeTitle)
                    .bold()


                // Video preview
                ZStack {

                    if let player {

                        VideoPlayer(player: player)
                            .frame(height: 360)

                        // Visual style overlay
                        styleOverlay
                            .allowsHitTesting(false)

                    } else {

                        ContentUnavailableView(
                            "No Video",
                            systemImage: "video.badge.plus",
                            description: Text("Choose a video to start")
                        )
                        .frame(height: 360)
                    }
                }
                .clipped()


                // Choose video from photo library
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .videos
                ) {
                    Label(
                        "Choose Video",
                        systemImage: "video"
                    )
                }
                .buttonStyle(.borderedProminent)


                // Playback speed section
                VStack(spacing: 10) {

                    Text("Playback Speed")
                        .font(.headline)

                    Text("Current Speed: \(speedText)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {

                        speedButton(
                            title: "0.5x",
                            speed: 0.5
                        )

                        speedButton(
                            title: "1x",
                            speed: 1.0
                        )

                        speedButton(
                            title: "2x",
                            speed: 2.0
                        )
                    }
                }


                // Visual style section
                VStack(spacing: 10) {

                    Text("Visual Style")
                        .font(.headline)

                    Text("Selected: \(selectedStyle)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {

                        styleButton(
                            title: "Normal"
                        )

                        styleButton(
                            title: "Warm"
                        )

                        styleButton(
                            title: "Dark"
                        )
                    }
                }


                if isLoading {
                    ProgressView("Loading Video...")
                }

                Spacer()
            }
            .padding()

            // Automatically load test.mp4 when app opens
            .onAppear {
                loadTestVideo()
            }

            // Runs when a new video is selected
            .onChange(of: selectedItem) { _, newItem in

                Task {
                    await loadVideo(from: newItem)
                }
            }
        }
    }


    // MARK: - Speed Buttons

    func speedButton(
        title: String,
        speed: Double
    ) -> some View {

        Button {
            playbackSpeed = speed

            player?.play()
            player?.rate = Float(speed)

        } label: {

            Text(title)
                .fontWeight(.medium)
                .frame(width: 60)
                .padding(.vertical, 8)
                .foregroundStyle(
                    playbackSpeed == speed
                    ? Color.white
                    : Color.primary
                )
                .background(
                    playbackSpeed == speed
                    ? Color.blue
                    : Color.gray.opacity(0.15),
                    in: RoundedRectangle(
                        cornerRadius: 10
                    )
                )
        }
        .buttonStyle(.plain)
    }


    // MARK: - Style Buttons

    func styleButton(
        title: String
    ) -> some View {

        Button {
            selectedStyle = title

        } label: {

            Text(title)
                .fontWeight(.medium)
                .frame(width: 70)
                .padding(.vertical, 8)
                .foregroundStyle(
                    selectedStyle == title
                    ? Color.white
                    : Color.primary
                )
                .background(
                    selectedStyle == title
                    ? Color.blue
                    : Color.gray.opacity(0.15),
                    in: RoundedRectangle(
                        cornerRadius: 10
                    )
                )
        }
        .buttonStyle(.plain)
    }


    // MARK: - Visual Style

    @ViewBuilder
    var styleOverlay: some View {

        if selectedStyle == "Warm" {

            Color.orange
                .opacity(0.18)
                .blendMode(.softLight)

        } else if selectedStyle == "Dark" {

            Color.black
                .opacity(0.35)

        } else {

            Color.clear
        }
    }


    // Current speed shown as text
    var speedText: String {

        if playbackSpeed == 0.5 {
            return "0.5x"

        } else if playbackSpeed == 2.0 {
            return "2x"

        } else {
            return "1x"
        }
    }


    // MARK: - Local Test Video

    func loadTestVideo() {

        guard let url = Bundle.main.url(
            forResource: "test",
            withExtension: "mp4"
        ) else {
            print("test.mp4 not found")
            return
        }

        player?.pause()

        player = AVPlayer(url: url)

        playbackSpeed = 1.0

        player?.play()
    }


    // MARK: - PhotosPicker Video

    @MainActor
    func loadVideo(
        from item: PhotosPickerItem?
    ) async {

        guard let item else {
            return
        }

        isLoading = true

        do {

            guard let movie =
                try await item.loadTransferable(
                    type: Movie.self
                )
            else {
                isLoading = false
                return
            }

            player?.pause()

            player = AVPlayer(
                url: movie.url
            )

            playbackSpeed = 1.0

            player?.play()

        } catch {

            print(
                "Video loading error: \(error)"
            )
        }

        isLoading = false
    }
}


#Preview {
    ContentView()
}

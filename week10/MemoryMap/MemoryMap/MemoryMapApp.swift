import SwiftUI
import SwiftData

// The app starts here and opens ContentView.
@main
struct MemoryMapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // SwiftData stores memories on this device so they are available the next time the app opens.
        .modelContainer(for: Memory.self)
    }
}

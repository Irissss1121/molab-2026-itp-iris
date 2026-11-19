import MapKit
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    // @Query loads saved memories, newest first, and refreshes the map and list when they change.
    @Query(sort: \Memory.date, order: .reverse) private var memories: [Memory]
    @StateObject private var locator = LocationManager()
    @State private var camera: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedPin: Memory?
    @State private var entry: MemoryEntry?

    var body: some View {
        NavigationStack {
            Map(position: $camera, selection: $selectedPin) {
                // The blue dot marks the device's current location. Each orange pin marks a saved memory.
                UserAnnotation()
                ForEach(memories) { memory in
                    Marker(memory.mood.isEmpty ? "Memory" : memory.mood,
                           systemImage: "bookmark.fill", coordinate: memory.coordinate)
                        .tint(.orange)
                        // The tag tells the map which Memory to assign to selectedPin when this pin is tapped.
                        .tag(memory)
                }
            }
            .mapControls {
                MapCompass()
                MapUserLocationButton()
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 12) {
                    NavigationLink {
                        // The list lets you open each memory even when several pins share the same spot.
                        memoryList
                    } label: {
                        HStack(spacing: 5) {
                            Text(memories.count == 1 ? "1 memory" : "\(memories.count) memories")
                            if !memories.isEmpty {
                                Image(systemName: "chevron.right").font(.caption)
                            }
                        }
                        .font(.headline)
                    }
                    .disabled(memories.isEmpty)
                    if locator.location == nil {
                        Text(locationHint)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Button {
                        if let coordinate = locator.location?.coordinate {
                            // Capture the location now so the pin stays here even if the user moves while writing.
                            entry = MemoryEntry(coordinate: coordinate)
                        }
                    } label: {
                        Label("Add Memory", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(locator.location == nil)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
            }
            .navigationTitle("Memory Map")
            .navigationBarTitleDisplayMode(.inline)
        }
        // Check permission when the app becomes active and stop tracking when it enters the background.
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                locator.start()
            } else if phase == .background {
                locator.stop()
            }
        }
        .onChange(of: selectedPin) { _, memory in
            if let memory { openMemory(memory) }
        }
        // A new entry opens the editor. Clear the selection on dismissal so the same pin can open again.
        .sheet(item: $entry, onDismiss: { selectedPin = nil }) { entry in
            MemoryEditor(entry: entry) {
                camera = .region(MKCoordinateRegion(center: entry.coordinate,
                                                    latitudinalMeters: 800, longitudinalMeters: 800))
            }
        }
    }

    private var memoryList: some View {
        List(memories) { memory in
            Button {
                openMemory(memory)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(memory.mood.isEmpty ? "Memory" : memory.mood).font(.headline)
                    if !memory.note.isEmpty {
                        Text(memory.note).lineLimit(2)
                    }
                    Text(memory.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .tint(.primary)
        }
        .navigationTitle("Memories")
    }

    private var locationHint: String {
        switch locator.authorization {
        case .denied:
            "Allow location access in Settings to add a memory."
        case .restricted:
            "Location access is restricted on this device."
        case .authorizedAlways, .authorizedWhenInUse:
            #if targetEnvironment(simulator)
            "Choose a place with Simulate Location in Xcode’s debug bar to enable Add Memory."
            #else
            "Waiting for your location…"
            #endif
        case .notDetermined:
            "Allow location access to add a memory."
        @unknown default:
            "Waiting for your location…"
        }
    }

    private func openMemory(_ memory: Memory) {
        entry = MemoryEntry(coordinate: memory.coordinate, memory: memory)
    }
}

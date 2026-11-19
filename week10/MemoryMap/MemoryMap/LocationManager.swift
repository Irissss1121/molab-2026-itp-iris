import Combine
import CoreLocation
import Foundation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    // Publishing location updates lets the map enable Add Memory when a coordinate arrives.
    @Published private(set) var location: CLLocation?
    @Published private(set) var authorization: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // Core Location calls the delegate methods below when the location or permission changes.
        manager.delegate = self
    }

    // Ask for permission on first use. Once access is granted, start receiving location updates.
    func start() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            stop()
        }
    }

    func stop() {
        manager.stopUpdatingLocation()
        location = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorization = manager.authorizationStatus
        if authorization != .notDetermined {
            start()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Core Location may send a cached reading first. Keep a valid reading from the last 30 seconds.
        guard let latest = locations.last, latest.horizontalAccuracy >= 0,
              abs(latest.timestamp.timeIntervalSinceNow) < 30 else { return }
        location = latest
    }

    // Clear the last location on failure so a new memory cannot use an old coordinate.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        location = nil
    }
}

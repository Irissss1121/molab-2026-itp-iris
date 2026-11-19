import CoreLocation
import Foundation
import SwiftData

// Each Memory represents one pin. @Model lets SwiftData save it and load it again.
@Model
final class Memory {
    var latitude: Double
    var longitude: Double
    var date: Date
    var mood = ""
    var note = ""

    // MapKit needs a coordinate, so we combine the stored latitude and longitude here.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(at coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        // Set the date when the memory is created. Later edits keep this timestamp.
        date = Date()
    }
}

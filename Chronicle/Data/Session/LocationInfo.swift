//
//  LocationInfo.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/4/24.
//

import Foundation
import MapKit

public struct LocationInfo: Codable {
    var name: String?
    var latitude: Double?
    var longitude: Double?
    
    init(name: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getMapData() -> MKMapItem? {
        guard let latitude, let longitude else { return nil }
        
        return MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
    }
}


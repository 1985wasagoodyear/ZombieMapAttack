//
//  CLLocation+Utility.swift
//  ZombieMapAttack
//
//  Created by K Y on 6/19/19.
//  Copyright © 2019 KY. All rights reserved.
//

import CoreLocation

struct LasVegasCoordinates {
    static let latitude = 36.1699 // N
    static let longitude = -115.1398 // W
    // 36.1699° N, 115.1398° W
}

extension CLLocationCoordinate2D {
    static var lasVegas: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: LasVegasCoordinates.latitude,
                                      longitude: LasVegasCoordinates.longitude)
    }
}

extension CLLocationDegrees {
    static func degrees(miles: Double) -> CLLocationDegrees {
        return miles / 69.0
    }
}

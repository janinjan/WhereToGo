//
//  PointOfInterrest.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 30/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit
import MapKit

class PointOfInterest: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    let interestCategory: InterestCategory

    init(coordinate: CLLocationCoordinate2D, interestCategory: InterestCategory) {
        self.coordinate = coordinate
        self.interestCategory = interestCategory
    }

    enum InterestCategory: String {
        case all
        case shop
        case food
        case hotels
        case bikes
        case water
    }
}

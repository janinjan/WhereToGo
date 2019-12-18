//
//  PointOfInterrest.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 30/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import MapKit

class PointOfInterest: NSObject, MKAnnotation {
    // MARK: - Properties
    let coordinate: CLLocationCoordinate2D
    let category: POIType
    let title: String?
    let address: String?
    let image: String?
    let phoneNumber: String?
    let website: String?

    // MARK: - Init
    init(coordinate: CLLocationCoordinate2D, category: POIType,
         title: String, address: String, image: String, phoneNumber: String, website: String) {
        self.coordinate = coordinate
        self.category = category
        self.title = title
        self.address = address
        self.image = image
        self.phoneNumber = phoneNumber
        self.website = website
    }
}

public enum City: CaseIterable {
    case naples, paris
    
    func name() -> String {
        switch (self){
        case .naples:
            return "Naples"
        case .paris:
            return "Paris"
        }
    }
}

public enum POIType: String {
    case all
    case shop
    case food
    case hotel
    case bike
    case water
}

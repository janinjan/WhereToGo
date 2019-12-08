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
    // MARK: - Properties
    var coordinate: CLLocationCoordinate2D
    let interestCategory: InterestCategory
    let title: String?
    var address: String?
    var image: String?
    var phoneNumber: String?
    var website: String?

    // MARK: - Init
    init(coordinate: CLLocationCoordinate2D, interestCategory: InterestCategory,
         title: String, address: String, image: String, phoneNumber: String, website: String) {
        self.coordinate = coordinate
        self.interestCategory = interestCategory
        self.title = title
        self.address = address
        self.image = image
        self.phoneNumber = phoneNumber
        self.website = website
    }
}

struct Location {
    static var shopsArray = [PointOfInterest]()
    static var foodArray = [PointOfInterest]()
    static var hotelsArray = [PointOfInterest]()
    static var bikesArray = [PointOfInterest]()
    static var waterArray = [PointOfInterest]()
}

enum City: CaseIterable {
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

public enum InterestCategory: String {
    case all
    case shop
    case food
    case hotel
    case bike
    case water
}

extension InterestCategory {
    var path: String {
        switch self {
        case .all:
            return "/naples/category"
        case .shop:
            return "/naples/category/shop"
        case .food:
            return "/naples/category/food"
        case .hotel:
            return "/naples/category/hotel"
        case .bike:
            return "/naples/category/bike"
        case .water:
            return "/naples/category/water"
        }
    }
}

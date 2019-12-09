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

public enum InterestCategory {
    case all(city: String)
    case shop(city: String)
    case food(city: String)
    case hotel(city: String)
    case bike(city: String)
    case water(city: String)
}

extension InterestCategory {
    var path: String {
        switch self {
        case .all(let city):
            return "/\(city)/category"
        case .shop(let city):
            return "/\(city)/category/shop"
        case .food(let city):
            return "/\(city)/category/food"
        case .hotel(let city):
            return "/\(city)/category/hotel"
        case .bike(let city):
            return "/\(city)/category/bike"
        case .water(let city):
            return "/\(city)/category/water"
        }
    }
}

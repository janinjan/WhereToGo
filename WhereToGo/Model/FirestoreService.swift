//
//  FirestoreService.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 04/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreLocation

class FirestoreService {
    // MARK: - Properties
    let db: Firestore!
    var coordinate = CLLocationCoordinate2D()

    // MARK: - Init
    init() {
        /// Start setup
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        /// End setup
        db = Firestore.firestore()
    }

    // MARK: - Methods
    func getCollection(url: InterestCategory, cityName: String, completionHandler: @escaping (PointOfInterest) -> Void) {
        let categoryRef = db.collection(url.path)
        categoryRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("\(error)")
            } else {
                for document in snapshot!.documents {
                    if let geopoint = document.get("coordinate") {
                        self.convertGepointInCoordinate(geopoint: geopoint) // convert geopoint in coordinate
                    }
                    let title = document.get("title")
                    let address = document.get("address")
                    let website = document.get("website")
                    let phoneNumber = document.get("phoneNumber")
                    let category = document.get("category") as? String
                    let categoryType: InterestCategory
                    switch category {
                    case "shop":
                        categoryType = .shop(city: cityName)
                    case "food":
                        categoryType = .food(city: cityName)
                    case "hotel":
                        categoryType = .hotel(city: cityName)
                    case "water":
                        categoryType = .water(city: cityName)
                    case "bike":
                        categoryType = .bike(city: cityName)
                    default:
                        categoryType = .all(city: cityName)
                    }
                    
                    let object = PointOfInterest(coordinate: self.coordinate, interestCategory: categoryType,
                                                 title: title as! String, address: address as! String,
                                                 image: "", phoneNumber: phoneNumber as! String, website: website as! String)
                    
                    self.addFetchObjectToArray(object: object) // add object to their corresponding arrays
                    completionHandler(object)
                }
            }
        }
    }

    private func convertGepointInCoordinate(geopoint: Any) {
        let point = geopoint as! GeoPoint
        let lat = point.latitude
        let long = point.longitude
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    private func addFetchObjectToArray(object: PointOfInterest) {
        switch object.interestCategory {
        case .shop:
            Location.shopsArray.append(object)
        case .food:
            Location.foodArray.append(object)
        case .hotel:
            Location.hotelsArray.append(object)
        case .bike:
            Location.bikesArray.append(object)
        case .water:
            Location.waterArray.append(object)
        case .all:
            break
        }
    }
}

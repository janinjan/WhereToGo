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

class FirestoreService: FirestoreProtocol {
    // MARK: - Properties
    let db: Firestore?
    var coordinate = CLLocationCoordinate2D()
    var poiDictionnary: [String: [PointOfInterest]] = [:]

    // MARK: - Init
    init() {
        /// Start setup
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        /// End setup
        db = Firestore.firestore()
    }

    // MARK: - Methods
    func getCollection(cityName: String, completion: @escaping (Result<[PointOfInterest], Error>) -> Void) {
        if let interest = self.poiDictionnary[cityName] {
            completion(.success(interest))
            return
        }
        var objects: [PointOfInterest] = []
        ["shop", "hotel", "bike", "water", "food"].forEach {
            let path = db?.collection("/\(cityName.lowercased())/category/\($0)")
            guard let categoryRef = path else { return }
            categoryRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("\(error)")
                    completion(.failure(error))
                } else {
                    guard let snapshot = snapshot else { return }
                    for document in snapshot.documents {
                        if let geopoint = document.get("coordinate") {
                            self.convertGepointInCoordinate(geopoint: geopoint) // convert geopoint in coordinate
                        }
                        guard let title = document.get("title") as? String else { return }
                        guard let address = document.get("address") as? String else { return }
                        guard let website = document.get("website") as? String else { return }
                        guard let phoneNumber = document.get("phoneNumber") as? String else { return }
                        guard let category = document.get("category") as? String else { return }
                        guard let convertedCategory = POIType(rawValue: category) else { return }
                        guard let image = document.get("image") as? String else { return }
                        let object = PointOfInterest(coordinate: self.coordinate,
                                                     category: convertedCategory,
                                                     title: title,
                                                     address: address,
                                                     image: image,
                                                     phoneNumber: phoneNumber,
                                                     website: website)
                        objects.append(object)
                        self.poiDictionnary[cityName] = objects
                    }
                    completion(.success(objects))
                }
            }
        }
    }

    private func convertGepointInCoordinate(geopoint: Any) {
        guard let point = geopoint as? GeoPoint else { return }
        let lat = point.latitude
        let long = point.longitude
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

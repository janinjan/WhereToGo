//
//  FirestoreTestsCase.swift
//  WhereToGoTests
//
//  Created by Janin Culhaoglu on 14/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import XCTest
import FirebaseFirestore
import CoreLocation
@testable import WhereToGo

class FirestoreTestsCase: XCTestCase {

    var receivedInfo = [String: PointOfInterest]()

    func test_get_collectionSuccess() {
        let firestoreServiceStub = FirestoreServiceStub()
        let cityName: String = "Naples"
        let place = PointOfInterest(
            coordinate: CLLocationCoordinate2D(latitude: 40.851203, longitude: 14.231299),
            category: POIType.shop,
            title: "Altromercato",
            address: "Via Giuseppe Orsi, 72, 80128 Napoli",
            image: "https://firebasestorage.googleapis.com/v0/b/wheretogodatas.appspot.com/o/naples%2Fshop%2Faltromercato_1.jpg?alt=media&token=c9b8ceec-0444-4d90-97a8-d21e4127581e",
            phoneNumber: "+39 081 5789053",
            website: "https://www.altromercato.it/it_it/")
        FirestoreServiceStub.stub = [cityName: [place]]

        let exp = expectation(description: "Wait for completion")

        firestoreServiceStub.getCollection(cityName: cityName, completion: { result in
            switch result {
            case let .success(pointOfInterest):
                XCTAssertEqual([place], pointOfInterest)
                XCTAssertEqual(cityName, firestoreServiceStub.cityName)
            case .failure:
                XCTFail("Should be success")
            }
            exp.fulfill()
        })

        wait(for: [exp], timeout: 1.0)
    }
}

class FirestoreServiceStub: FirestoreProtocol {

    static var stub: [String: [PointOfInterest]] = [:]

    var cityName: String {
        return FirestoreServiceStub.stub.first!.key
    }

    func getCollection(cityName: String, completion: @escaping (Result<[PointOfInterest], Error>) -> Void) {
        completion(.success(FirestoreServiceStub.stub[cityName]!))
    }
}

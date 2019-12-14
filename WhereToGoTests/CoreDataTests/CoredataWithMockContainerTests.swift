//
//  CoredataWithMockContainerTests.swift
//  WhereToGoTests
//
//  Created by Janin Culhaoglu on 14/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
@testable import WhereToGo

class CoredataWithMockContainerTests: XCTestCase {

    // MARK: - Properties

    lazy var mockContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhereToGo")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (_, error) in
            XCTAssertNil(error)
        })
        return container
    }()

    // MARK: - Helper Methods

    override func setUp() {
        EcoPlaceEntity.deleteAll(viewContext: mockContainer.viewContext)
    }

    private func addPlaceToFavorite(into managedObjectContext: NSManagedObjectContext) {
        let newPlaceInFavorite = EcoPlaceEntity(context: managedObjectContext)
        let image = "https://firebasestorage.googleapis.com/v0/b/wheretogodatas.appspot.com/o/naples%2Fshop%2Faltromercato_1.jpg?alt=media&token=c9b8ceec-0444-4d90-97a8-d21e4127581e"
        guard let imageUrl = URL(string: image) else { return }

        newPlaceInFavorite.titleAtb = "Altromercato"
        newPlaceInFavorite.addressAtb = "Via Giuseppe Orsi, 72, 80128 Napoli"
        newPlaceInFavorite.websiteAtb = "https://www.altromercato.it/it_it/"
        newPlaceInFavorite.phoneAtb = "+39 081 5789053"
        newPlaceInFavorite.imageAtb = try? Data(contentsOf: imageUrl)
        newPlaceInFavorite.coordinateLatAtb = 40.851203
        newPlaceInFavorite.coordinateLongAtb = 14.231299
    }

    // MARK: - Unit Tests

    func testAddThousandPlaceToFavoriteInPersistentContainer() {
        for _ in 0 ..< 1000 {
            addPlaceToFavorite(into: mockContainer.newBackgroundContext())
        }
        XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
    }

    func testDeleteAllFavoritePlaceInPersistentContainer() {
        // Given
        addPlaceToFavorite(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        // When
        EcoPlaceEntity.deleteAll(viewContext: mockContainer.viewContext)
        // Then
        XCTAssertEqual(EcoPlaceEntity.fetchAll(viewContext: mockContainer.viewContext), [])
    }

    func testDeleteOneFavoritePlaceInPersistentContainer() {
        // Given
        addPlaceToFavorite(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        // When
        EcoPlaceEntity.delete(names: ["Altromercato"], viewContext: mockContainer.viewContext)
        // Then
        XCTAssertEqual(EcoPlaceEntity.fetchAll(viewContext: mockContainer.viewContext), [])
    }

    func testAddOneFavoritePlaceInPersistentContainerShouldReturnOneElementInArray() {
        // Given
        let title = "Altromercato"
        let coordinate = CLLocation(latitude: 40.851203, longitude: 14.231299)
        let address = "Via Giuseppe Orsi, 72, 80128 Napoli"
        let website = "https://www.altromercato.it/it_it/"
        let image = "https://firebasestorage.googleapis.com/v0/b/wheretogodatas.appspot.com/o/naples%2Fshop%2Faltromercato_1.jpg?alt=media&token=c9b8ceec-0444-4d90-97a8-d21e4127581e"
        let phoneNumber = "+39 081 5789053"
        let interestCategory = InterestCategory.shop(city: "naples")

        let selectedPlaceInfo: [String: Any] = ["title": title, "latCoordinate": coordinate.coordinate.latitude, "longCoordinate": coordinate.coordinate.longitude, "address": address, "image": image, "phoneNumber": phoneNumber, "interestCategory": interestCategory, "website": website]
        // When
        EcoPlaceEntity.addPlaceToFavorite(ecoPlace: selectedPlaceInfo, viewContext: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        // Then
        XCTAssertEqual(EcoPlaceEntity.fetchAll(viewContext: mockContainer.viewContext).count, 1 )
    }

    func testPlaceAlreadyInFavoriteShouldReturnTrueIfAlreadyExist() {
        // Given
        addPlaceToFavorite(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        // When
        addPlaceToFavorite(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        // Then
        XCTAssertEqual(EcoPlaceEntity.placeAlreadyInFavorite(name: "Altromercato",
                                                             viewContext: mockContainer.viewContext), true)
    }

    func testPlaceAlreadyInFavoriteShouldReturnFalseIfEmptyList() {
        _ = EcoPlaceEntity.fetchAll(viewContext: mockContainer.viewContext)
        XCTAssertFalse(EcoPlaceEntity.placeAlreadyInFavorite(name: "Altromercato",
                                                             viewContext: mockContainer.viewContext))
    }
}

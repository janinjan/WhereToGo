//
//  EcoPlaceEntity.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 12/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import Foundation
import CoreData

class EcoPlaceEntity: NSManagedObject {

    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [EcoPlaceEntity] {
        let request: NSFetchRequest<EcoPlaceEntity> = EcoPlaceEntity.fetchRequest()
        guard let favoritePlaces = try? viewContext.fetch(request) else { return [] }
        return favoritePlaces
    }

    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        EcoPlaceEntity.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0)})
        try? viewContext.save()
    }

    static func addPlaceToFavorite(ecoPlace: [String: Any], viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let favPlace = EcoPlaceEntity(context: viewContext)
        favPlace.titleAtb = ecoPlace["title"] as? String
        favPlace.addressAtb = ecoPlace["address"] as? String
        favPlace.websiteAtb = ecoPlace["website"] as? String
        favPlace.phoneAtb = ecoPlace["phoneNumber"] as? String
        guard let latCoordinate = ecoPlace["latCoordinate"] as? Double else { return }
        favPlace.coordinateLatAtb = latCoordinate
        guard let longtCoordinate = ecoPlace["longCoordinate"] as? Double else { return }
        favPlace.coordinateLongAtb = longtCoordinate

        guard let image = ecoPlace["image"] as? String else { return }
        guard let imageUrl = URL(string: image) else { return }
        favPlace.imageAtb = try? Data(contentsOf: imageUrl)

        try? viewContext.save() // save in viewContext
    }

    static func delete(names: [String], viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let request: NSFetchRequest<EcoPlaceEntity> = EcoPlaceEntity.fetchRequest()
        for name in names {
            request.predicate = NSPredicate(format: "titleAtb  = %@", name)
            guard let favoritePlaces = try? viewContext.fetch(request) else { return }
            guard let place = favoritePlaces.first else { return }
            viewContext.delete(place)
        }
        try? viewContext.save()
    }

    // If a place is already in favorite, function returns true
    static func placeAlreadyInFavorite(name: String,
                                       viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> Bool {
        let request: NSFetchRequest<EcoPlaceEntity> = EcoPlaceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "titleAtb = %@", name)
        guard let favoritePlace = try? viewContext.fetch(request) else { return false }
        if favoritePlace.isEmpty {
            return false
        }
        return true
    }
}

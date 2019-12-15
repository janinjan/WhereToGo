//
//  FirestoreProtocol.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 14/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import Foundation

protocol FirestoreProtocol {
    func getCollection(cityName: String, completion: @escaping (Result<[PointOfInterest], Error>) -> Void)
}

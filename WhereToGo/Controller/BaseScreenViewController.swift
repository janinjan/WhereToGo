//
//  BaseScreenViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 27/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit
import MapKit

class BaseScreenViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties
    let categories = [(#imageLiteral(resourceName: "AllButton"),"All"),(#imageLiteral(resourceName: "ShopButton"), "Shop"), (#imageLiteral(resourceName: "FoodButton"), "Food"), (#imageLiteral(resourceName: "HotelsButton"), "Hotels"), (#imageLiteral(resourceName: "BikesButton"),  "Bikes"), (#imageLiteral(resourceName: "WaterButton"), "Water")]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// =========================================
// MARK: - CollectionView datasource
// =========================================
extension BaseScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.category = categories[indexPath.row]
        return cell
    }
}

// =========================================
// MARK: - CollectionView delegate
// =========================================
extension BaseScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        selectedCell.categoryName.textColor = .black
        selectedCell.chevronDownSymbol.tintColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        selectedCell.categoryName.textColor = .darkGray
        selectedCell.chevronDownSymbol.tintColor = .clear
    }
}

// =========================================
// MARK: - CollectionView delegateFlowLayout
// =========================================
extension BaseScreenViewController: UICollectionViewDelegateFlowLayout {
    // Item spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

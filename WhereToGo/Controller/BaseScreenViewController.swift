//
//  BaseScreenViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 27/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// This is the controller of the Base Screen with all categories and MapKit View
class BaseScreenViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties
    let categories = [(#imageLiteral(resourceName: "AllButton"),"All"),(#imageLiteral(resourceName: "ShopButton"), "Shop"), (#imageLiteral(resourceName: "FoodButton"), "Food"), (#imageLiteral(resourceName: "HotelsButton"), "Hotels"), (#imageLiteral(resourceName: "BikesButton"),  "Bikes"), (#imageLiteral(resourceName: "WaterButton"), "Water")]

    var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 40.8663100, longitude: 14.2864100) // Naples coordinate
    }

    let locationManager = CLLocationManager() // get a location manager reference

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        checkLocationServices()
    }

    // MARK: - Methods
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationAuthorization() { // Check the authorization status
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // present alert
            break
        case .denied:
            // present alert
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            fatalError()
        }
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // present alert
        }
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
        selectedCell.categoryName.textColor = .greyLabel
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

// =========================================
// MARK: - CoreLocation Manager Delegate
// =========================================
extension BaseScreenViewController: CLLocationManagerDelegate {
    // Everytime the user change location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// =========================================
// MARK: - MapKitView Delegate
// =========================================
extension BaseScreenViewController: MKMapViewDelegate {
    func setupMap(coordinate: CLLocationCoordinate2D, myLatitude: Double, myLongitude: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLatitude, longitudeDelta: myLongitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    func setup() {
        setupMap(coordinate: coordinateInit, myLatitude: 0.07, myLongitude: 0.07)
        mapView.delegate = self
    }
}

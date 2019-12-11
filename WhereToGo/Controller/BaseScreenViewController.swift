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
class BaseScreenViewController: UIViewController, CityPickerDelegate {

    enum SliderState {
        case expanded, collapsed
    }

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityName: UIButton!

    // MARK: - Properties
    let categories = [(#imageLiteral(resourceName: "AllButton"),"All"),(#imageLiteral(resourceName: "ShopButton"), "Shop"), (#imageLiteral(resourceName: "FoodButton"), "Food"), (#imageLiteral(resourceName: "HotelsButton"), "Hotel"), (#imageLiteral(resourceName: "BikesButton"),  "Bike"), (#imageLiteral(resourceName: "WaterButton"), "Water")]
    var selectedCity: City = .naples
    let locationManager = CLLocationManager() // get a location manager reference
    let naplesCoordinates = CLLocationCoordinate2D(latitude: 40.8663100, longitude: 14.2864100)
    let parisCoordinates = CLLocationCoordinate2D(latitude: 48.864716, longitude: 2.349014)

    var coordinateInit: CLLocationCoordinate2D {
        switch selectedCity {
        case .naples:
            return naplesCoordinates
        case .paris:
            return parisCoordinates
        }
    }

    var userLat: Double = 0.0
    var userLong: Double = 0.0
    var usersCity = ""
    var currentPlace: [String: Any] = [:]

    let segueIdentifier = "BaseToCities"

    let firestoreService = FirestoreService()

    // MARK: - Actions
    @IBAction func didTapChangeCity(_ sender: UIButton) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    // MARK: - Properties (Slider)
    var sliderViewController: SliderViewController!
    var visualEffectView: UIVisualEffectView!
    let screenSize: CGRect = UIScreen.main.bounds
    let sliderRatio: CGFloat = 0.9
    let sliderHandleAreaRatio: CGFloat = 0.35
    var sliderHeight: CGFloat = 500
    var sliderHandleAreaHeight: CGFloat = 120
    var sliderVisible = false

    var nextState:SliderState {
        return sliderVisible ? .collapsed : .expanded
    }

    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapCoordinate()
        checkLocationServices()
        mapView.register(PointOfInterestAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        setupSlider()
        getDatas(city: "paris")
        getDatas(city: "naples")
        addAllAnnotations()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("didReceiveData"), object: nil)
    }

    @objc func onDidReceiveData(_ notification: Notification) {
        guard let selectedPlaceInfo = notification.object as? [String: Any] else { return }
        self.currentPlace = selectedPlaceInfo

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newsliderViewController = (storyboard.instantiateViewController(withIdentifier: "infoPlace") as? DetailsViewController) else { return }
        newsliderViewController.curentPlace = currentPlace // pass data to detailVC
        self.navigationController?.pushViewController(newsliderViewController, animated: true)
    }

    // MARK: - Segue to Cities TableView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let tableVC = segue.destination as? CitiesViewController else { return }
            tableVC.delegate = self
        }
    }

    // MARK: - Methods (Delegate, MapKit)
    func changeCity(name: City) {
        cityName.setTitle(name.name() + " ⌵", for: .normal)
        selectedCity = name
        addAllAnnotations()
        setupMapCoordinate() // Update view to selected city's coordinates
    }

    // Retreive user's city name with geocoder
    private func retreiveCityName(latitude: Double, longitude: Double) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemark, error) in
            if let placemark = placemark?.first {
                guard let cityName = placemark.locality else { return }
                self.usersCity = cityName
            }
        }
    }

    // Get datas from Firebase
    func getDatas(city: String) {
        firestoreService.getCollection(url: .shop(city: city), cityName: city)
        firestoreService.getCollection(url: .food(city: city), cityName: city)
        firestoreService.getCollection(url: .hotel(city: city), cityName: city)
        firestoreService.getCollection(url: .bike(city: city), cityName: city)
        firestoreService.getCollection(url: .water(city: city), cityName: city)
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func checkLocationAuthorization() { // Check the authorization status
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            presentAlert(ofType: .locationRestricted)
            break
        case .denied:
            presentAlert(ofType: .permissionDenied)
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

    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            presentAlert(ofType: .locationDisabled) // Display alert letting the users know that they have to turn Location on
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
        removeAllAnnotations()
        mapView.addAnnotations(pointsOfInterest(for: indexPath.item))
        if sliderVisible { // collapsed the cardView if a category is selected
            animateTransitionIfNeeded(state: .collapsed, duration: 1)
        }
    }

    private func pointsOfInterest(for index: Int) -> [PointOfInterest] {
        let allPoints = Location.shopsArray + Location.foodArray + Location.hotelsArray + Location.bikesArray + Location.waterArray
        let indexAndPoint: [Int: [PointOfInterest]] = [
            0 : allPoints,
            1 : Location.shopsArray,
            2 : Location.foodArray,
            3 : Location.hotelsArray,
            4 : Location.bikesArray,
            5 : Location.waterArray
        ]
        return indexAndPoint[index] ?? allPoints
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.userLat = location.coordinate.latitude
            self.userLong = location.coordinate.longitude
            retreiveCityName(latitude: userLat, longitude: userLong)
        }
    }
}

// =========================================
// MARK: - MapKitView Delegate
// =========================================
extension BaseScreenViewController: MKMapViewDelegate {
    private func setupMap(coordinate: CLLocationCoordinate2D, myLatitude: Double, myLongitude: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLatitude, longitudeDelta: myLongitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    private func setupMapCoordinate() {
        setupMap(coordinate: coordinateInit, myLatitude: 0.07, myLongitude: 0.07)
        mapView.delegate = self
    }

    private func addAllAnnotations() { // Add all eco-friendly places in the map
        mapView.addAnnotations(pointsOfInterest(for: 0))
    }

    private func removeAllAnnotations() {
        mapView.removeAnnotations(pointsOfInterest(for: 0))
    }
}

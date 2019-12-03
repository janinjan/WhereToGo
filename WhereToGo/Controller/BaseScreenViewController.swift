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

    enum SliderState {
          case expanded, collapsed
      }

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties
    let categories = [(#imageLiteral(resourceName: "AllButton"),"All"),(#imageLiteral(resourceName: "ShopButton"), "Shop"), (#imageLiteral(resourceName: "FoodButton"), "Food"), (#imageLiteral(resourceName: "HotelsButton"), "Hotels"), (#imageLiteral(resourceName: "BikesButton"),  "Bikes"), (#imageLiteral(resourceName: "WaterButton"), "Water")]

    var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 40.8663100, longitude: 14.2864100) // Naples coordinate
    }
    let locationManager = CLLocationManager() // get a location manager reference

    // MARK: - Properties (Slider)
    var sliderViewController: SliderViewController!
    var visualEffectView: UIVisualEffectView!
    let screenSize: CGRect = UIScreen.main.bounds
    var sliderRatio: CGFloat = 0.9
    var sliderHandleAreaRatio: CGFloat = 0.35
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
        collectionView.dataSource = self
        collectionView.delegate = self
        setupMapCoordinate()
        checkLocationServices()
        mapView.register(PointOfInterestAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        setupSlider()
    }

    // MARK: - Methods (Slider)
    func setupSlider() {
        sliderHeight = screenSize.height * sliderRatio - 110
        sliderHandleAreaHeight = 200
        
        visualEffectView = UIVisualEffectView()
        self.visualEffectView.frame = self.mapView.frame
        
        sliderViewController = (self.storyboard?.instantiateViewController(withIdentifier: "slider") as! SliderViewController)
        self.addChild(sliderViewController)
        self.view.addSubview(sliderViewController.view)
        
        sliderViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - sliderHandleAreaHeight, width: self.view.bounds.width, height: sliderHeight)
        sliderViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseScreenViewController.handleSliderTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BaseScreenViewController.handleSliderPan(recognizer:)))
        
        sliderViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        sliderViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleSliderTap(recognizer:UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            startInteractiveTransition(state: nextState, duration: 0.8)
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    @objc func handleSliderPan(recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.5)
        case .changed:
            let translation = recognizer.translation(in: self.sliderViewController.handleArea)
            let fractionCompleted = translation.y / sliderHeight
            updateInteractiveTransition(fractionCompleted: sliderVisible ? fractionCompleted : -fractionCompleted)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state:SliderState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.sliderViewController.view.frame.origin.y = self.view.frame.height - self.sliderHeight
                case .collapsed:
                    self.sliderViewController.view.frame.origin.y = self.view.frame.height - self.sliderHandleAreaHeight
                }
            }
            frameAnimator.addCompletion { _ in
                self.sliderVisible = !self.sliderVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            self.runningAnimations.append(frameAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.mapView.addSubview(self.visualEffectView)
                    self.visualEffectView.effect = UIBlurEffect(style: .light)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }

            blurAnimator.addCompletion {_ in
                switch state {
                case .expanded:
                    break
                case .collapsed:
                    self.visualEffectView.removeFromSuperview()
                }
            }

            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    func startInteractiveTransition(state:SliderState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition () {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    // MARK: - Methods (MapKit)
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationAuthorization() { // Check the authorization status
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

    func checkLocationServices() {
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

    func setupMapCoordinate() {
        setupMap(coordinate: coordinateInit, myLatitude: 0.07, myLongitude: 0.07)
        mapView.delegate = self
    }
}

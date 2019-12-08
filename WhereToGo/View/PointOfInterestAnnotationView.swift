//
//  PointOfInterestAnnotationView.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 30/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit
import MapKit

class PointOfInterestAnnotationView: MKMarkerAnnotationView {

    // Change the color of the annotation according to the category and add callout buttons
    override var annotation: MKAnnotation? {
        willSet {
            if let place = newValue as? PointOfInterest {
                switch place.interestCategory {
                case .all:
                    break
                case .shop:
                    markerTintColor = UIColor.shopColor
                case .food:
                    markerTintColor = UIColor.foodColor
                case .hotel:
                    markerTintColor = UIColor.hotelsColor
                case .bike:
                    markerTintColor = UIColor.bikesColor
                case .water:
                    markerTintColor = UIColor.waterColor
                }
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            leftCalloutAccessoryView = setupLeftButton()
            rightCalloutAccessoryView = setupRightButton()
        }
    }

    // Create letf button for the direction
    func setupLeftButton() -> UIButton {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftButton.setImage(UIImage(named: "walkingPerson"), for: .normal)
        leftButton.addTarget(self, action: #selector(gps), for: .touchUpInside)
        return leftButton
    }

    // Gps direction to the selected place by walk
    @objc func gps() {
        guard let annotation = annotation as? PointOfInterest else { return }
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let map = MKMapItem(placemark: placemark)
        map.name = annotation.title
        map.openInMaps(launchOptions: options)
    }

    // Create right button for information
    func setupRightButton() -> UIButton {
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.addTarget(self, action: #selector(displayInfo), for: .touchUpInside)
        return rightButton
    }

    @objc func displayInfo() {
        // To do
    }
}

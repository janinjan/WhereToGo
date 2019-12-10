//
//  UIViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 01/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

extension UIViewController {
    /// enum for every error cases
    enum AlertType {
        case permissionDenied
        case locationRestricted
        case locationDisabled
    }

    /// Displays an alert with a custom message by using switch
    func presentAlert(ofType type: AlertType) {
        var title: String
        var message: String

        switch type {
        case .permissionDenied:
            title = "Permiss Denied"
            message = "Please go to settings and turn on Location Service for this app."
        case .locationRestricted:
            title = "Location Services Restricted"
            message = "Please enable Location services for this app."
        case .locationDisabled:
            title = "Locations Services Disabled"
            message = "Please enable location services for this app."
        }

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

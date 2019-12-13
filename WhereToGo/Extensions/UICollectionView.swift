//
//  UICollectionView.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 13/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

extension UICollectionView {

    /// Displays a custom message when array is empty
    func setEmptyMessage(_ message: String) {
        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        self.backgroundView = label
    }

    func restore() {
        self.backgroundView = nil
    }
}


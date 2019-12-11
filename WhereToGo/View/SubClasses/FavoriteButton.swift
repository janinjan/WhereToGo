//
//  FavoriteButton.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 11/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

// Creates a custom subClass of UIButton for the toggle Button
class FavoriteButton: UIButton {

    var isOn = false // keep track if the button is in On or in Off state

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }

    func initButton() { // Set up the UI of the button
        layer.cornerRadius = 0.5 * layer.bounds.size.width
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.masksToBounds = false
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5

        setTitleColor(.white, for: .normal)
        setTitle("♡", for: .normal)
        addTarget(self, action: #selector(FavoriteButton.buttonPressed), for: .touchUpInside)
    }

    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }

    func activateButton(bool: Bool) {
        isOn = bool

        let bgColor = bool ? UIColor.white : .clear // round background color is white when selected
        let title = bool ? "♥︎" : "♡" // filled heart when selected
        let titleColor = bool ? UIColor.shopColor : .white

        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
    }
}

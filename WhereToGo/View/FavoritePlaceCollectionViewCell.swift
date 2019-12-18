//
//  FavoritePlaceCollectionViewCell.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 13/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit
/**
 * FavoritePlaceCollectionViewCell inherits from UICollectionViewCell class.
 It defines the favorite place list cell's elements
 */
class FavoritePlaceCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var favEcoPlaceImage: UIImageView!
    @IBOutlet weak var favEcoPlaceName: UILabel!
    @IBOutlet weak var favEcoPlaceAddress: UILabel!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!

    // MARK: - Properties

    /// Displays for FavoritesViewController
    var favorite: EcoPlaceEntity? {
        didSet {
            guard let favorite = favorite else { return }
            favEcoPlaceName.text = favorite.titleAtb // Displays eco place's name

            guard let data = favorite.imageAtb else { return }
            guard let dataImage = UIImage(data: data) else { return }
            favEcoPlaceImage.image = dataImage // Displays place's image

            guard let address = favorite.addressAtb else { return }
            favEcoPlaceAddress.text = address
        }
    }

    /// Implement Editing Mode
    /**
     * A property observer is created which will toggle the visibility of checkmark ImageView
     according if the collection view controller is in editing mode or not.
     */
    var isInEditingMode: Bool = false {
        didSet {
            favEcoPlaceAddress.isHidden = isInEditingMode
            checkImageView.isHidden = !isInEditingMode
        }
    }
    /// Implement Editing Mode
    /**
     * Another property observer is created which will display/remove the checkmark
     when the cell is selected or not.
     */
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                checkImageView.image = UIImage(named: isSelected ? "Checked" : "Unchecked")
                let bgColor = isSelected ? UIColor.shopColor : UIColor.whiteGrey
                whiteView.backgroundColor = bgColor
            }
        }
    }

    // MARK: - Methods

    override func awakeFromNib() {
        addShadowsToCell()
    }

    /// Add shadows and border to cells
    private func addShadowsToCell() {
        contentView.layer.cornerRadius = 8.0
        whiteView.layer.cornerRadius = 8.0
        favEcoPlaceImage.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
    }
}

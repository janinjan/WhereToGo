//
//  CategoryCollectionViewCell.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 28/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var chevronDownSymbol: UIImageView!

    // MARK: - Properties
    var category: (UIImage, String)? {
        didSet {
            categoryImageView.image = category?.0
            categoryName.text = category?.1
        }
    }

    override func awakeFromNib() {
        chevronDownSymbol.image = UIImage(named: "ChevronDown")
        categoryName.textColor = .greyLabel
    }
}

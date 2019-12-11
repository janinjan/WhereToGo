//
//  SliderViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 01/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

typealias Category = (title: String, description: String, icon: UIImage?)

class SliderViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var handleArea: UIView!

    var myParent: BaseScreenViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        myParent = self.parent as? BaseScreenViewController
    }

    var categories: [Category] = [
        ("Restaurants",
         """
        - Local food
        - Organic and/or seasonal products
        - Resort to short food circuits
        - Stock and expiration dates management
        - Energy efficient equipment
        - Efficient water management
        - Use sustainable furniture and utensils
        - Recovering of biowaste
        - Ecological cleaning products
        - No plastic use
        - Waste separation and management
        - Staff training and active information to guests
        - Sustainable delivery service
        """
            , UIImage(named: "FoodGlyphGray")),
        ("Hotels",
         """
        - Renewable energy sources
        - Optimized building energy performance
        - Energy saving lamps
        - Energy efficient air conditioning
        - Efficient water management
        - Staff training and active information to guests
        - Ecological cleaning products
        - Waste separation
        - Furnishings made out of natural and/or recycled materials
        - No plastic use
        - Organic and/or local food
        - Car-free accessibility
        - Bike rental
        """
            , UIImage(named: "HotelGlyphGray"))]
}

// =========================================
// MARK: - TableView datasource
// =========================================
extension SliderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as? InfoTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = categories[indexPath.row].title
        cell.descriptionLabel.text = categories[indexPath.row].description
        cell.iconImageView.image = categories[indexPath.row].icon
        return cell
    }
}

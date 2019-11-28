//
//  CitiesViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 28/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    var cities = ["Paris", "Naples", "London"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// =========================================
// MARK: - TableView datasource
// =========================================
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cityName = cities[indexPath.row]
        cell.textLabel?.text = cityName
        return cell
    }
}

// =========================================
// MARK: - TableView delegate
// =========================================
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        dismiss(animated: true) // Close controller after city selection
    }
}

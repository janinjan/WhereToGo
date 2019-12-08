//
//  CitiesViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 28/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

/**
 * Creation of a delegate protocol that defines the responsabilities of the delegate
 */
protocol CityPickerDelegate: class {
    func changeCity(name: City)
}

class CitiesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    weak var delegate: CityPickerDelegate? // Created a delegate property
    var citySymbolsImage = (#imageLiteral(resourceName: "ParisSymbol"), #imageLiteral(resourceName: "NaplesSymbol"))

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // Hides empty cells from TableView
    }
}

// =========================================
// MARK: - TableView datasource
// =========================================
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let cityName = City.allCases[indexPath.row].name()
        cell.textLabel?.text = cityName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        switch cityName {
        case City.paris.name():
            cell.imageView?.image = citySymbolsImage.0
        case City.naples.name():
            cell.imageView?.image = citySymbolsImage.1
        default:
            break
        }
        return cell
    }
}

// =========================================
// MARK: - TableView delegate
// =========================================
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedCity = City.allCases[indexPath.row]
        delegate?.changeCity(name: selectedCity)
        dismiss(animated: true) // Close controller after city selection
    }
}

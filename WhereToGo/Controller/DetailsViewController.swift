//
//  DetailsViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 11/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var placesImage: UIImageView!
    @IBOutlet weak var placesName: UILabel!
    @IBOutlet weak var placesAddress: UILabel!
    @IBOutlet weak var placesPhone: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var favButton: FavoriteButton!

    // MARK: - Properties
    private var myParent: BaseScreenViewController?
    var curentPlace: [String: Any] = [:]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if EcoPlaceEntity.placeAlreadyInFavorite(name: (curentPlace["title"] as? String)!) {
            favButton.activateButton(bool: true)
        }
        getAndDisplayCurrentPlaceInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        myParent = self.parent as? BaseScreenViewController
    }

    @IBAction func didTapFavorite(_ sender: Any) {
        if favButton.isOn {
            EcoPlaceEntity.addPlaceToFavorite(ecoPlace: curentPlace)
        } else {
            EcoPlaceEntity.delete(names: [(curentPlace["title"] as? String)!])
        }
    }

    @IBAction func didTapWebsite(_ sender: UIButton) {
        guard let website = curentPlace["website"]  as? String else { return }
        guard let url = URL(string: website) else { return }
        UIApplication.shared.open(url) // Open the place's website in Safari
    }

    private func setupUI() {
        addShadows(to: placesImage)
        websiteButton.layer.cornerRadius = 5
    }

    private func getAndDisplayCurrentPlaceInfo() {
        guard let title = curentPlace["title"] as? String else { return }
        guard let address = curentPlace["address"]  as? String else { return }
        guard let phoneNumber = curentPlace["phoneNumber"]  as? String else { return }
        guard let imagePlaceUrl = curentPlace["image"]  as? String else { return }
        guard let website = curentPlace["website"] as? String else { return }

        convertUrlToImage(imagePlaceUrl)
        // Display Informations
        placesName.text = title
        placesAddress.text = address
        placesPhone.text = phoneNumber
        if website.isEmpty {
            websiteButton.isHidden = true
        }
    }

    /// Convert String URL to UIImage
    private func convertUrlToImage(_ imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        if let data = try? Data(contentsOf: url) {
            guard let image = UIImage(data: data as Data) else { return }  // Convert url to image
            self.placesImage.image = image
        }
    }

    /// Add shadows and border to cells
    private func addShadows(to image: UIImageView) {
        image.layer.cornerRadius = 8.0
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.clear.cgColor
        image.layer.masksToBounds = false
        image.layer.shadowColor = UIColor.gray.cgColor
        image.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        image.layer.shadowRadius = 4.0
        image.layer.shadowOpacity = 1.0
        image.layer.masksToBounds = false
    }
}

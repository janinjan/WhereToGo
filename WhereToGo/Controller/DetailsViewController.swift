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
    @IBOutlet weak var placesPhone: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var favButton: FavoriteButton!
    @IBOutlet weak var contentViewOfImage: UIView!
    
    // MARK: - Properties
    private var myParent: BaseScreenViewController?
    var curentPlace: [String: Any] = [:]
    var favoritePlace: EcoPlaceEntity?
    var placeDetailsIsAskedFromFavorite: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if placeDetailsIsAskedFromFavorite {
            favButton.isHidden = true
            displayFavoritePlaceInformation()
        } else {
            if EcoPlaceEntity.placeAlreadyInFavorite(name: (curentPlace["title"] as? String)!) {
                favButton.activateButton(bool: true)
            }
            favButton.isHidden = false
            getAndDisplayCurrentPlaceInfo()
        }
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

    @IBAction func didTapPhoneNumber(_ sender: UIButton) {
        guard let phone = curentPlace["phoneNumber"] as? String else { return }
        print(phone)
        guard let url = URL(string: phone) else { return }
        print(phone)
        UIApplication.shared.open(url)
    }

    @IBAction func didTapWebsite(_ sender: UIButton) {
        if placeDetailsIsAskedFromFavorite {
            guard let currentFavoriteWebsite = favoritePlace?.websiteAtb else { return }
            guard let url = URL(string: currentFavoriteWebsite) else { return }
            UIApplication.shared.open(url) // Open favorite recipe directions in Safari
        } else {
            guard let currentWebsite = curentPlace["website"]  as? String else { return }
            guard let url = URL(string: currentWebsite) else { return }
            UIApplication.shared.open(url) // Open the place's website in Safari
        }
    }

    private func setupUI() {
        addShadows(to: contentViewOfImage)
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
        placesPhone.setTitle(phoneNumber, for: .normal)
        if website.isEmpty {
            websiteButton.isHidden = true
        }
    }

    private func displayFavoritePlaceInformation() {
        placesName.text = favoritePlace?.titleAtb
        placesAddress.text = favoritePlace?.addressAtb
        placesPhone.setTitle(favoritePlace?.phoneAtb, for: .normal)
        guard let currentFavWebsite = favoritePlace?.websiteAtb else { return }
        if currentFavWebsite.isEmpty {
            websiteButton.isHidden = true
        }
        guard let data = favoritePlace?.imageAtb else { return }
        guard let dataImage = UIImage(data: data) else { return }
        placesImage.image = dataImage // Displays favorite place's image
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
    private func addShadows(to contentView: UIView) {
        placesImage.layer.cornerRadius = 6.0
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.85
    }
}

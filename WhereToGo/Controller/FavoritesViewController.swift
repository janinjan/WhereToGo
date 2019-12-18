//
//  FavoritesViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 28/11/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    private var favoritePlaces = EcoPlaceEntity.fetchAll()
    private var placesNames = [String]()
    var favoritePlace: EcoPlaceEntity?
    let segueToFavoriteDetailViewIdentifier = "segueFromFavToDetailVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true // Toolbar with Trash icon is hidden
        if favoritePlaces.isEmpty {
            editButtonItem.isEnabled = false
        } else {
            editButtonItem.isEnabled = true
        }
        navigationItem.rightBarButtonItem = editButtonItem // Add Edit Button item in navigation bar
        favoritePlaces = EcoPlaceEntity.fetchAll()
        collectionView.reloadData()
    }

    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        if let selectedCellsIndex = collectionView.indexPathsForSelectedItems {
            let items = selectedCellsIndex.map { $0.item }.sorted().reversed()
            for item in items {
                guard let name = favoritePlaces[item].titleAtb else { return }
                placesNames.append(name) // Add place's name to names array
                favoritePlaces.remove(at: item) // Remove items from favoritePlaces array
            }
            collectionView.deleteItems(at: selectedCellsIndex) // Delete selected cells from CollectionVC
            EcoPlaceEntity.delete(names: placesNames) // Delete selected place stored in CoreData
            collectionView.reloadData()
            placesNames = []
            navigationController?.setToolbarHidden(true, animated: true) // Hide the trash icon
        }
    }

    // This method will check if a cell is in editing mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing // select multiple cells
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
            let cell = collectionView!.cellForItem(at: indexPath) as? FavoritePlaceCollectionViewCell
            cell!.isInEditingMode = editing
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == segueToFavoriteDetailViewIdentifier {
               if let destination = segue.destination as? DetailsViewController {
                   destination.placeDetailsIsAskedFromFavorite = true
                   destination.favoritePlace = favoritePlace // Perfom is in FavoriteVCDelegate extension
               }
           }
       }
}

// =========================================
// MARK: - CollectionView Delegate FlowLayout
// =========================================

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    // Defines the Cell Size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (view.frame.width - 30) / 2
        return CGSize(width: side, height: side)
    }

    // Item spacing (y axi)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// =========================================
// MARK: - CollectionView data source
// =========================================

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoritePlaces.count == 0 {
            collectionView.setEmptyMessage("Add places to favorite")
        } else {
            collectionView.restore()
        }
        return favoritePlaces.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let favoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath)
            as? FavoritePlaceCollectionViewCell else { return UICollectionViewCell() }
        favoriteCell.favorite = favoritePlaces[indexPath.row]
        favoriteCell.isInEditingMode = isEditing
        return favoriteCell
    }
}

// =========================================
// MARK: - CollectionView delegate
// =========================================

extension FavoritesViewController: UICollectionViewDelegate {
    // If a cell is selected the trash icon is displayed, otherwise it remains hidden
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            favoritePlace = favoritePlaces[indexPath.row]
            self.performSegue(withIdentifier: segueToFavoriteDetailViewIdentifier, sender: self)
            navigationController?.setToolbarHidden(true, animated: true)
        } else {
            navigationController?.setToolbarHidden(false, animated: true)
        }
    }

    // If a cell is deselected and there are no other cells selected, the trash icon is hidden.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if collectionView.indexPathsForSelectedItems!.count == 0 {
                navigationController?.setToolbarHidden(true, animated: true)
            }
        }
    }
}

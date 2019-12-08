//
//  SliderViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 01/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var handleArea: UIView!
    var myParent: BaseScreenViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        myParent = self.parent as? BaseScreenViewController
    }
}

extension SliderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        return cell
    }
}

// =========================================
// MARK: - CollectionView Delegate FlowLayout
// =========================================

extension SliderViewController: UICollectionViewDelegateFlowLayout {
    // Cell Size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (view.frame.width - 30)
        return CGSize(width: side, height: 258)
    }
}

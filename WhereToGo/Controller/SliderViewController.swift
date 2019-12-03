//
//  SliderViewController.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 01/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {

    @IBOutlet weak var handleArea: UIView!
    var myParent: BaseScreenViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myParent = self.parent as? BaseScreenViewController
    }
}

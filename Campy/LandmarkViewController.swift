//
//  LandmarkViewController.swift
//  Campy
//
//  Created by Steve Malsam on 11/22/19.
//  Copyright © 2019 Steve Malsam. All rights reserved.
//

import UIKit

class LandmarkViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var about: UILabel!
    
    var campsite: Campsite? {
        didSet {
            if let nameLabel = self.name,
                let aboutLabel = self.about {
                nameLabel.text = campsite?.title
                aboutLabel.text = campsite?.about
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.campsite?.title
        self.about.text = self.campsite?.about
    }
}

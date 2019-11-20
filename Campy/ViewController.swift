//
//  ViewController.swift
//  Campy
//
//  Created by Steve Malsam on 11/19/19.
//  Copyright © 2019 Steve Malsam. All rights reserved.
//

import MapKit
import UIKit

// 44.4280° N, 110.5885° W - Coordinates of Yellowstone
let YELLOWSTONE_COORDINATES = CLLocationCoordinate2DMake(44.43, -110.52)
let YELLOWSTONE_SPAN = MKCoordinateSpan(latitudeDelta: 1.6, longitudeDelta: 1.2)

class ViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let yellowstoneRegion = MKCoordinateRegion(center: YELLOWSTONE_COORDINATES, span: YELLOWSTONE_SPAN)
        
        self.map.setRegion(yellowstoneRegion, animated: false)
    }
}

extension ViewController:MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("Visible Region: \(mapView.region)")
    }
}


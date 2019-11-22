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
let YELLOWSTONE_SPAN = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 1.2)

struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}

struct Campsite: Decodable {
    let name: String
    let coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.coordinates.latitude, longitude: self.coordinates.longitude)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    private var campsites = [Campsite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let yellowstoneRegion = MKCoordinateRegion(center: YELLOWSTONE_COORDINATES, span: YELLOWSTONE_SPAN)
        
        self.map.setRegion(yellowstoneRegion, animated: false)
        self.loadLandmarks()
        self.addCampsites()
    }
    
    func loadLandmarks() {
        if let path = Bundle.main.path(forResource: "park_locations", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let sites = try decoder.decode([Campsite].self, from: data)
                self.campsites = sites
            } catch {
                
            }
        }
    }
    
    func addCampsites() {
        for campsite in self.campsites {
            let annotation = MKPointAnnotation()
            annotation.title = campsite.name
            annotation.coordinate = campsite.locationCoordinate
            self.map.addAnnotation(annotation)
        }
    }
}

extension ViewController:MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("Visible Region: \(mapView.region)")
    }
}


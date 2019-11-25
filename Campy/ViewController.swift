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

class Campsite: NSObject, Decodable, MKAnnotation {
    let title: String?
    let about: String
    let coordinates: Coordinates
    var coordinate: CLLocationCoordinate2D {
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
        self.map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PIN")
        self.loadLandmarks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard case segue.identifier = "Detail",
            let annotationView = sender as? MKMarkerAnnotationView,
            let campsite = annotationView.annotation as? Campsite,
            let detailVC = segue.destination as? LandmarkViewController else {
            return
        }
        
        detailVC.campsite = campsite
    }
    
    func loadLandmarks() {
        if let path = Bundle.main.path(forResource: "park_locations", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let sites = try decoder.decode([Campsite].self, from: data)
                self.campsites = sites
                self.map.addAnnotations(self.campsites)
            } catch {
                
            }
        }
    }
}

extension ViewController:MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("Visible Region: \(mapView.region)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Campsite else { return nil }

        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "PIN", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Unable to deque proper Annotation view")
        }

//        pinView.image = #imageLiteral(resourceName: "campIcon")
        pinView.canShowCallout = true
        pinView.calloutOffset = CGPoint(x: -5, y: -5)
        pinView.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "campIcon"))
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
      self.performSegue(withIdentifier: "Detail", sender: view)
    }
}

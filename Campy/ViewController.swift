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

class ViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    private var campsites = [Campsite]()
    private var campers = [Camper]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let yellowstoneRegion = MKCoordinateRegion(center: YELLOWSTONE_COORDINATES, span: YELLOWSTONE_SPAN)
        
        self.map.setRegion(yellowstoneRegion, animated: false)
        self.map.register(CampsiteView.self, forAnnotationViewWithReuseIdentifier: "PIN")
        self.map.register(CamperView.self, forAnnotationViewWithReuseIdentifier: "CAMPER")
        self.loadLandmarks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCamperTimer()
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
                
                for _ in 0...10 {
                    let coordinate = self.generateRandomCoordinates(min: 0, max: 100000)
                    let camper = Camper(coordinate: coordinate)
                    self.campers.append(camper)
                }
                self.map.addAnnotations(campers)
                
            } catch {
                
            }
        }
    }
    
    func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        //Get the Current Location's longitude and latitude
        let currentLong = YELLOWSTONE_COORDINATES.longitude
        let currentLat = YELLOWSTONE_COORDINATES.latitude

        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000

        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)

        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)

        //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)

        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }
    }
    
    @objc func setupCamperTimer() {
        // setup to delay 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.map.removeAnnotations(self.campers)
            self.campers.removeFirst(5)
            for _ in 1...5 {
                let coordinate = self.generateRandomCoordinates(min: 0, max: 100000)
                let camper = Camper(coordinate: coordinate)
                self.campers.append(camper)
            }
            
            self.map.addAnnotations(self.campers)
            self.perform(#selector(self.setupCamperTimer))
        }
    }
}

extension ViewController:MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("Visible Region: \(mapView.region)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Campsite {
            guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "PIN", for: annotation) as? CampsiteView else {
                fatalError("Unable to deque proper Annotation view")
            }

            pinView.canShowCallout = true
            pinView.calloutOffset = CGPoint(x: -5, y: -5)
            pinView.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "campIcon"))
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        } else if let annotation = annotation as? Camper {
            guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "CAMPER", for: annotation) as? CamperView else {
                fatalError("Unable to deque proper Annotation view")
            }

            pinView.canShowCallout = true
            pinView.calloutOffset = CGPoint(x: -5, y: -5)
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
        if let view = view as? CampsiteView {
            self.performSegue(withIdentifier: "Detail", sender: view)
        }
    }
}

//
//  Annotations.swift
//  Campy
//
//  Created by Steve Malsam on 11/24/19.
//  Copyright © 2019 Steve Malsam. All rights reserved.
//

import Foundation
import MapKit

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

class CampsiteView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      glyphImage = #imageLiteral(resourceName: "campIcon")
    }
  }
}


class Camper: NSObject, MKAnnotation {
    let title: String?
    let phoneNumber: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String = "Camper", phoneNumber: String = "(949)867-5309", coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.phoneNumber = phoneNumber
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return self.phoneNumber
    }
}

class CamperView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            glyphImage = #imageLiteral(resourceName: "camperIcon")
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = "CamperCluster"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

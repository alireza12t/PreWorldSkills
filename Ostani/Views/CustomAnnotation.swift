//
//  CustomAnnotation.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import Foundation
import MapKit


class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage = UIImage(named: "marker")!
    var subtitle: String?
    var data: CenterListElement? = nil

    init(name: String, coordinate: CLLocationCoordinate2D, data: CenterListElement? = nil) {
        self.title = name
        self.coordinate = coordinate
        self.subtitle = ""
        self.data = data
        self.image = UIImage(named: "marker")!
        super.init()
    }
}

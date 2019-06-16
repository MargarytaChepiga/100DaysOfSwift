//
//  Capital.swift
//  Project16
//
//  Created by margaret on 2019-06-16.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit
// needed because we are using CLLocationCoordinate2D and MKAnnotations that are defined in MapKit
import MapKit
// with map annotations we have to create a class that will inherit from NSObject
// because it needs to be interactive with Apple's Objective-C code
class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    // basic initializer
    // use self. here because the parameters being passed in are the same name as our properties
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}

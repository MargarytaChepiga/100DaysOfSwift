//
//  Picture.swift
//  Picture-Capture-App
//
//  Created by margaret on 2019-05-22.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class Picture: NSObject, NSCoding {
    var name: String
    var pictureImage: String
    
    init(name: String, pictureImage: String) {
        
        self.name = name
        self.pictureImage = pictureImage
        
    }
    
    required init(coder aDecoder: NSCoder) {
        // we’re adding as? typecasting and nil coalescing just in case we get invalid data back
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        pictureImage = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(pictureImage, forKey: "image")
    }
}

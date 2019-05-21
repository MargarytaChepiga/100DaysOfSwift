//
//  Person.swift
//  Project10
//
//  Created by margaret on 2019-05-14.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

// The reason we inherit from NSObject is again because it's required to use NSCoding – although cunningly Swift won't mention that to you, your app will just crash
// If we want to save the people array to UserDefaults we'll need to conform to the NSCoding protocol
class Person: NSObject, NSCoding {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        
        self.name = name
        self.image = image
        
    }
    
    // NSCoder is responsible for encoding and decoding our data so it can be used with UserDefaults
    // init must be declared with required keyword, which means that "if anyone tries to subclass this class, they are required to implement this method."
    required init(coder aDecoder: NSCoder) {
        // we’re adding as? typecasting and nil coalescing just in case we get invalid data back
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    
}

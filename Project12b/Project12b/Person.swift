//
//  Person.swift
//  Project12b
//
//  Created by margaret on 2019-05-22.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

// The reason we inherit from NSObject is again because it's required to use NSCoding – although cunningly Swift won't mention that to you, your app will just crash
// If we want to save the people array to UserDefaults we'll need to conform to the NSCoding protocol
class Person: NSObject, Codable {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        
        self.name = name
        self.image = image
        
    }
    
    
}

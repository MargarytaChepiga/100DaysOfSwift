//
//  Country.swift
//  CountriesFacts
//
//  Created by margaret on 2019-06-13.
//  Copyright © 2019 margaret. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var capital: String
    var region: String
    var population: Int
    var area: Float?
    var flag: String
    var nativeName: String
    var currencies: [Currency]
    var languages: [Language]
}

struct Currency: Codable {
    var code: String?
    var name: String?
    var symbol: String?
}

struct Language: Codable {
    var name: String
}

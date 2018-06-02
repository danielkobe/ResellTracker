//
//  Shoe.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/13/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import Foundation
import CoreData

class Shoe {
    var shoeName: String
    var imgURL: String
    var styleCode: String
    var colorway: String
    var brand: String
    var retailPrice: String
    var releaseDate: String
    var objectID: NSManagedObjectID?
    var size: Float
    var avgPrice: Float
    
    init() {
        self.shoeName = ""
        self.imgURL = ""
        self.styleCode = ""
        self.colorway = ""
        self.brand = ""
        self.retailPrice = ""
        self.releaseDate = ""
        self.size = 0.0
        self.avgPrice = 0.0
    }
}



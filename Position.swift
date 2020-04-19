//
//  Position.swift
//  FlowerShop
//
//  Created by Arnav Reddy on 4/16/20.
//  Copyright © 2020 Brian Advent. All rights reserved.
//

import Foundation
import ARKit

class Position {
    var x: Float
    var y: Float
    var z: Float
    var vector: SCNVector3
    
    init(x: Float, y: Float, z: Float, vector: SCNVector3) {
        self.x = x
        self.y = y
        self.z = z
        self.vector = vector
    }
}

//
//  Avatars.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/29.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import Foundation

class Avatar {
    var icon: String
    var background: String
    var colour : String
    
    init(icon: String, background: String, colour: String) {
        self.icon = icon
        self.background = background
        self.colour = colour
    }
}

let avatars = [Avatar(icon: "purple-monster-1", background: "planet-1", colour: "Purple"),
               Avatar(icon: "green-monster-1", background: "planet-2", colour: "Green")]

//Avatar Name
let avatarNameFirst = ["Bubbly","Fluffy"]

let avatarNameLast = ["Clown","Lizard"]

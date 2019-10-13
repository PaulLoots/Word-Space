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
               Avatar(icon: "green-monster-1", background: "planet-2", colour: "Green"),
               Avatar(icon: "lightblue-monster-1", background: "planet-1", colour: "LightBlue"),
               Avatar(icon: "blue-monster-1", background: "planet-1", colour: "Blue"),
               Avatar(icon: "red-monster-1", background: "planet-1", colour: "Red"),
               Avatar(icon: "orange-monster-1", background: "planet-1", colour: "Orange"),
               Avatar(icon: "yellow-monster-1", background: "planet-1", colour: "Yellow"),
               Avatar(icon: "pink-monster-1", background: "planet-1", colour: "Pink")]

//Avatar Name
let avatarNameFirst = ["Bubbly","Fluffy"]

let avatarNameLast = ["Clown","Lizard"]

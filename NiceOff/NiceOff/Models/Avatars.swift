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
               Avatar(icon: "lightblue-monster-1", background: "planet-3", colour: "LightBlue"),
               Avatar(icon: "blue-monster-1", background: "planet-4", colour: "Blue"),
               Avatar(icon: "red-monster-1", background: "planet-5", colour: "Red"),
               Avatar(icon: "orange-monster-1", background: "planet-1", colour: "Orange"),
               Avatar(icon: "yellow-monster-1", background: "planet-2", colour: "Yellow"),
               Avatar(icon: "pink-monster-1", background: "planet-3", colour: "Pink"),
               Avatar(icon: "purple-monster-2", background: "planet-1", colour: "Purple"),
               Avatar(icon: "green-monster-2", background: "planet-2", colour: "Green"),
               Avatar(icon: "lightblue-monster-2", background: "planet-3", colour: "LightBlue"),
               Avatar(icon: "blue-monster-2", background: "planet-4", colour: "Blue"),
               Avatar(icon: "red-monster-2", background: "planet-5", colour: "Red"),
               Avatar(icon: "orange-monster-2", background: "planet-1", colour: "Orange"),
               Avatar(icon: "yellow-monster-2", background: "planet-4", colour: "Yellow"),
               Avatar(icon: "pink-monster-2", background: "planet-5", colour: "Pink")]

//Avatar Name
let avatarNameFirst = ["Bubbly","Fluffy","Adorable","Charming","Cozy","Fearless","Glitter","Quirky"]

let avatarNameLast = ["Clown","Lizard","Catfish","Tarantula","Sunflower","Honeybee","Starlet"]

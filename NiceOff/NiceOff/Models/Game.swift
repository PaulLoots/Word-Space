//
//  Game.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/14.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import Foundation

class Game {
    var passPhrase: String
    var catagory: String
    var currentRound : Int
    var currentRoundCatagory : String
    var id : String
    
    init(passPhrase: String, catagory: String, currentRound: Int, currentRoundCatagory: String, id: String) {
        self.passPhrase = passPhrase
        self.catagory = catagory
        self.currentRound = currentRound
        self.currentRoundCatagory = currentRoundCatagory
        self.id = id
    }
}

class Player {
    var name: String
    var avatar: String
    var score : Int
    var id : String
    
    init(name: String, avatar: String, score: Int, id: String) {
        self.name = name
        self.avatar = avatar
        self.score = score
        self.id = id
    }
}

class Sentence {
    var text: String
    var emotion: String
    var round : Int
    var likes : Int
    
    init(text: String, emotion: String, round: Int, likes: Int) {
        self.text = text
        self.emotion = emotion
        self.round = round
        self.likes = likes
    }
}

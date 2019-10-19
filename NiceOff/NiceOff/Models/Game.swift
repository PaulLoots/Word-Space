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
    var catagory: String
    var round : Int
    var likes : Int
    var score : Int
    var playerID : String
    
    init(text: String, catagory: String, round: Int, likes: Int, score : Int, playerID: String) {
        self.text = text
        self.catagory = catagory
        self.round = round
        self.likes = likes
        self.score = score
        self.playerID = playerID
    }
}

class ScoreItem {
    var playerID: String
    var playerName: String
    var playerAvatar : String
    var sentence : String
    var sentenceScore : Int
    var totalScore : Int
    var likes : Int
    
    init(playerID: String, playerName: String, playerAvatar: String, sentence: String, sentenceScore : Int, totalScore: Int, likes: Int) {
        self.playerID = playerID
        self.playerName = playerName
        self.playerAvatar = playerAvatar
        self.sentence = sentence
        self.sentenceScore = sentenceScore
        self.totalScore = totalScore
        self.likes = likes
    }
}

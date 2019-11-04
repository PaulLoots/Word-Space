//
//  Ref.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/29.
//  Copyright © 2019 Paul Loots. All rights reserved.
//
import AVFoundation
import Foundation

let CURRENT_AVATAR_INDEX = "current_avatar_index"
let AVATAR_NAME = "avatar_name"

//Game
let GAME_CREATION_DATE = "creation_date"
let GAME_PASS_PHRASE = "pass_phrase"
let GAME_CATAGORY = "catagory"
let GAME_CURRENT_ROUND = "current_round"
let GAME_CURRENT_ROUND_CATAGORY = "current_round_catagory"

//Player
let PLAYER_NAME = "name"
let PLAYER_AVATAR = "avatar"
let PLAYER_SCORE = "score"
let PLAYER_ID = "id"

//Sentence
let SENTENCE_TEXT = "text"
let SENTENCE_CATAGORY =  "catagory"
let SENTENCE_ROUNDS =  "round"
let SENTENCE_LIKES =  "likes"
let SENTENCE_SCORE =  "score"
let SENTENCE_PLAYERID =  "player_id"

//Word
let WORD_TEXT = "word"
let WORD_TYPE = "type"
let WORD_CATAGORY = "catagory"

//Sounds
var soundItemSelect = "itemSelect"
var soundButtonPress = "buttonPress"
var soundCalculating = "calculating"
var soundCalculationComplete = "calculationComplete"
var soundError = "error"
var soundErrorCountdown = "errorCountdown"
var soundButtonSelect = "buttonSelect"
var soundLiked = "liked"
var soundMenuSelect = "menuSelect"
var soundWin = "win"
var soundGameStart = "gameStart"
var soundGameStartCountdown = "gameStartCountdown"
var soundcalculation_verylow = "calculation_verylow"
var soundcalculation_low = "calculation_low"
var soundcalculation_medium = "calculation_medium"
var soundcalculation_high = "calculation_high"

//Sounds
var player: AVAudioPlayer?

//MARK: - Sound

func playSound(soundName: String) {
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }

    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        /* iOS 10 and earlier require the following line:
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

        guard let player = player else { return }

        player.play()

    } catch let error {
        print(error.localizedDescription)
    }
}

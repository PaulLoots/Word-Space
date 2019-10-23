//
//  GameApi.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/14.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import Foundation

import Foundation
import Firebase

class GameApi {
    
    let db = Firestore.firestore()
    
    private let gameCollection = "game"
    private let playerCollection = "players"
    
    //MARK: - Game
    
    private var gameListner: ListenerRegistration? = nil
    
    func setGame(documentData: [String : Any],onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        db.collection(gameCollection).document(Api.User.currentUserId).setData(documentData, merge: true) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                onError(error?.localizedDescription ?? "ERROR")
            } else {
                onSuccess()
            }
        }
    }
    
    func deleteGame(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        db.collection(gameCollection).document(Api.User.currentUserId).collection(playerCollection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                onError("Error Deleting Game \(err.localizedDescription)")
            } else {
                for document in  querySnapshot?.documents ?? [] {
                    document.reference.delete()
                }
                self.db.collection(self.gameCollection).document(Api.User.currentUserId).collection(self.sentenceCollection).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        onError("Error Deleting Game \(err.localizedDescription)")
                    } else {
                        for document in  querySnapshot?.documents ?? [] {
                            document.reference.delete()
                        }
                        Firestore.firestore().collection(self.gameCollection).document(Api.User.currentUserId).delete() { error in
                            if let error = error {
                                onError("Error Deleting Game \(error.localizedDescription)")
                            } else {
                                onSuccess()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getGame(passPhrase: String, onSuccess: @escaping(Game) -> Void, onNotFound: @escaping() -> Void, onError: @escaping() -> Void) {
        db.collection(gameCollection).whereField(GAME_PASS_PHRASE, isEqualTo: passPhrase)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    onError()
                } else {
                    if querySnapshot?.documents.count ?? 0 > 0 {
                        let documentID = querySnapshot?.documents[0].documentID ?? "nil"
                        self.gameListner = self.db.collection(self.gameCollection).document(documentID)
                        .addSnapshotListener { querySnapshot, error in
                            guard let document = querySnapshot?.data() else {
                                //print("Error fetching documents: \(error!)")
                                return
                            }
                            let game = Game(passPhrase: document[GAME_PASS_PHRASE] as? String ?? "", catagory: document[GAME_CATAGORY] as? String ?? "", currentRound: document[GAME_CURRENT_ROUND] as? Int ?? 0, currentRoundCatagory: document[GAME_CURRENT_ROUND_CATAGORY] as? String ?? "", id: documentID)
                            print("Document")
                            onSuccess(game)
                        }
                    } else {
                        onNotFound()
                    }
                }
        }
    }
    
    func removeGetGameObservers(){
        if let gameListner = gameListner {
            gameListner.remove()
        }
    }
    
    
    //MARK: - Players
    
    private var playersListner: ListenerRegistration? = nil
    
    func addPlayer(documentData: [String : Any],gameID: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        db.collection(gameCollection).document(gameID).collection(playerCollection).document(Api.User.currentUserId).setData(documentData, merge: true) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                onError(error?.localizedDescription ?? "ERROR")
            } else {
                onSuccess()
            }
        }
    }
    
    func getPlayers(gameID: String, onSuccess: @escaping([Player]) -> Void, onGameEnded: @escaping() -> Void) {
        playersListner = db.collection(gameCollection).document(gameID).collection(playerCollection)
        .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                onGameEnded()
                return
            }
            var players:[Player] = []
            for player in documents {
                players.append(Player(name: player[PLAYER_NAME] as? String ?? "", avatar: player[PLAYER_AVATAR] as? String ?? "", score: player[PLAYER_SCORE] as? Int ?? 0, id: player.documentID))
            }
            onSuccess(players)
        }
    }
    
    func removePlayerFromGame(gameID: String, onSuccess: @escaping() -> Void) {
        db.collection(gameCollection).document(gameID).collection(playerCollection).document(Api.User.currentUserId).delete() { error in
            if let error = error {
                print("Error Deleting Game \(error.localizedDescription)")
            } else {
                onSuccess()
            }
        }
    }
    
    func removeGetPlayersObservers(){
        if let playersListner = playersListner {
            playersListner.remove()
        }
    }
    //MARK: - Sentences
    
    private let sentenceCollection = "sentences"
    private var sentenceListner: ListenerRegistration? = nil
    
    func addSentence(sentenceID: String, documentData: [String : Any], gameID: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        db.collection(gameCollection).document(gameID).collection(sentenceCollection).document(sentenceID).setData(documentData, merge: true) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                onError(error?.localizedDescription ?? "ERROR")
            } else {
                onSuccess()
            }
        }
    }
    
    func likeSentence(sentenceID: String, gameID: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        let documentData = [
            SENTENCE_LIKES: FieldValue.increment(Int64(1))
            ] as [String : Any]
        db.collection(gameCollection).document(gameID).collection(sentenceCollection).document(sentenceID).setData(documentData, merge: true) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                onError(error?.localizedDescription ?? "ERROR")
            } else {
                onSuccess()
            }
        }
    }
    
    func getSentences(gameID: String, onSuccess: @escaping([Sentence]) -> Void, onGameEnded: @escaping() -> Void) {
        sentenceListner = db.collection(gameCollection).document(gameID).collection(sentenceCollection)
        .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                onGameEnded()
                return
            }
            var sentences:[Sentence] = []
            for sentence in documents {
                sentences.append(Sentence(text: sentence[SENTENCE_TEXT] as? String ?? "", catagory: sentence[SENTENCE_CATAGORY] as? String ?? "", round: sentence[SENTENCE_ROUNDS] as? Int ?? 0, likes: sentence[SENTENCE_LIKES] as? Int ?? 0, score: sentence[SENTENCE_SCORE] as? Int ?? 0, playerID: sentence[SENTENCE_PLAYERID] as? String ?? ""))
            }
            onSuccess(sentences)
        }
    }
    
    func getFavoriteSentence(gameID: String, onSuccess: @escaping(ScoreItem) -> Void, onEmpty: @escaping() -> Void) {
        sentenceListner = db.collection(gameCollection).document(gameID).collection(sentenceCollection)
        .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                onEmpty()
                return
            }
            var favoriteSentence = Sentence(text: "", catagory: "", round: 0, likes: 0, score: 0, playerID: "nil")
            for sentence in documents {
                if sentence[SENTENCE_LIKES] as? Int ?? 0 > favoriteSentence.likes {
                    favoriteSentence = Sentence(text: sentence[SENTENCE_TEXT] as? String ?? "", catagory: sentence[SENTENCE_CATAGORY] as? String ?? "", round: sentence[SENTENCE_ROUNDS] as? Int ?? 0, likes: sentence[SENTENCE_LIKES] as? Int ?? 0, score: sentence[SENTENCE_SCORE] as? Int ?? 0, playerID: sentence[SENTENCE_PLAYERID] as? String ?? "")
                }
            }
            if favoriteSentence.playerID != "nil" {
                self.db.collection(self.gameCollection).document(gameID).collection(self.playerCollection).document(favoriteSentence.playerID).getDocument { (document, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                            onEmpty()
                        } else {
                            let favoriteReturn = ScoreItem(playerID: document?.data()?[PLAYER_ID] as? String ?? "", playerName: document?.data()?[PLAYER_NAME] as? String ?? "", playerAvatar: document?.data()?[PLAYER_AVATAR] as? String ?? "", sentence: favoriteSentence.text, sentenceScore: favoriteSentence.score, totalScore: 0, likes: favoriteSentence.likes)
                            onSuccess(favoriteReturn)
                        }
                }
            } else {
                onEmpty()
            }
        }
    }
    
    func removeGetSentencesObservers(){
        if let sentenceListner = sentenceListner {
            sentenceListner.remove()
        }
    }
    
    //MARK: - Score Item
    
    func getScoreItems(gameID: String, currentRound: Int, onSuccess: @escaping([ScoreItem]) -> Void, onGameEnded: @escaping() -> Void) {
         getPlayers(gameID: gameID, onSuccess: { (playerData) in
            self.getSentences(gameID: gameID, onSuccess: { (sentenceData) in
                var scoreItems:[ScoreItem] = []
                for (index, player) in playerData.enumerated() {
                        var playerTotalScore = 0
                        for sentenceItem in sentenceData {
                            if player.id == sentenceItem.playerID {
                                playerTotalScore += sentenceItem.score
                            }
                        }
                        scoreItems.append(ScoreItem(playerID: player.id, playerName: player.name, playerAvatar: player.avatar, sentence: "none", sentenceScore: 0, totalScore: playerTotalScore, likes: 0))
                        for sentence in sentenceData {
                            if sentence.round == currentRound {
                                if player.id == sentence.playerID {
                                    scoreItems[index] = ScoreItem(playerID: player.id, playerName: player.name, playerAvatar: player.avatar, sentence: sentence.text, sentenceScore: sentence.score, totalScore: playerTotalScore, likes: sentence.likes)
                                }
                            }
                        }
                    }
                    onSuccess(scoreItems)
                }, onGameEnded: {
                    onGameEnded()
                })
        }, onGameEnded: {
            onGameEnded()
        })
    }
    
    func removeGetScoreItemsObservers(){
        if let sentenceListner = sentenceListner {
            sentenceListner.remove()
        }
        if let playersListner = playersListner {
            playersListner.remove()
        }
    }
}

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
}

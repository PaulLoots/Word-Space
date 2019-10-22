//
//  WordApi.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/21.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import Foundation

import Foundation
import Firebase

class WordApi {
    
    let db = Firestore.firestore()
    
    private let wordCollection = "words"
    private let suggestedWordCollection = "suggestedWords"

    
    //MARK: - Suggested Words
    
    func addSuggestedWord(documentData: [String : Any],onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        db.collection(suggestedWordCollection).document().setData(documentData, merge: true) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                onError(error?.localizedDescription ?? "ERROR")
            } else {
                onSuccess()
            }
        }
    }
    
    func removeSuggestedWord(word: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
         db.collection(suggestedWordCollection).whereField(WORD_TEXT, isEqualTo: word)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    onError(err.localizedDescription)
                } else {
                    print(querySnapshot?.count)
                    if querySnapshot?.documents.count ?? 0 > 0 {
                        let documentID = querySnapshot?.documents[0].documentID ?? "nil"
                        self.db.collection(self.suggestedWordCollection).document(documentID).delete() { error in
                            if let error = error {
                                print("Error Deleting Game \(error.localizedDescription)")
                                onError(error.localizedDescription)
                            } else {
                                onSuccess()
                            }
                        }
                    } else {
                        onError("not found")
                    }
                }
        }
    }
    
    func getSuggestedWords(onSuccess: @escaping([SuggestedWord]) -> Void, onError: @escaping() -> Void) {
        db.collection(suggestedWordCollection).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    onError()
                } else {
                    var sugggestedWords: [SuggestedWord] = []
                    
                    for document in querySnapshot?.documents ?? [] {
                        sugggestedWords.append(SuggestedWord(word: document.data()[WORD_TEXT] as? String ?? "", type: document.data()[WORD_TYPE] as? String ?? ""))
                    }
                    
                    onSuccess(sugggestedWords)
                }
        }
    }
    
    //MARK: - Game Words
    
    func addGameWord(catagory: String, word: String,onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        db.collection(wordCollection).document(wordCollection).updateData([
        catagory: FieldValue.arrayUnion([word])
        ]) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                onError(error?.localizedDescription ?? "ERROR")
            } else {
                onSuccess()
            }
        }
    }
}

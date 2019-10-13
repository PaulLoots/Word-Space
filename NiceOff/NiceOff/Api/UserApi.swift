//
//  UserApi.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/13.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class UserApi {
    
    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }
    
    func signInAnonymously(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
              print(error.localizedDescription)
              return
          }
          onSuccess()
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}

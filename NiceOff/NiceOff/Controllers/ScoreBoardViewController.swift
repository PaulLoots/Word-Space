//
//  ScoreBoardViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/08.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ScoreBoardViewController: UIViewController {

    //Player Data
    var enteredSentence = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calculateScore()
    }
    
    func calculateScore() {
        print(enteredSentence)
    }
}

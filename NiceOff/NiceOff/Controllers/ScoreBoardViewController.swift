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
import UICircularProgressRing

class ScoreBoardViewController: UIViewController {

    //Player Data
    var enteredSentence = ""

    @IBOutlet weak var scoreRing: UICircularProgressRing!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calculateScore()
    }
    
    func calculateScore() {
        //getToneValue(sentenceString:enteredSentence)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.scoreRing.startProgress(to: 80, duration: 2.0)
        }
    }
    
    // MARK: - Ai Request
    
    func getToneValue(sentenceString:String) {
        guard let correctedSentence = sentenceString.addingPercentEncoding(withAllowedCharacters: .symbols) else {
        print("Error. cannot cast name into String")
        return
        }
        
        let apiKey = "Qa2dXZ3ZDFZ-uMFmjsu3TJIQMnel0GJFIUNGgCAkwkn0"
        let urlString = "https://gateway-lon.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19&sentences=false&text=\(correctedSentence)"
        
        let url = URL(string: urlString)
        
        Alamofire.request(url!)
        .authenticate(user: "apiKey", password: apiKey)
//            .validate()
            .responseJSON { (response) in
                switch response.result {
                case.success(let value):
                    let json = JSON(value)
                        //print(json)
                    for n in 0...4 {
                        //print(json["document_tone"]["tone_categories"][0]["tones"])
                        let toneName = json["document_tone"]["tone_categories"][0]["tones"][n]["tone_name"].rawString()
                        let toneScore = json["document_tone"]["tone_categories"][0]["tones"][n]["score"].rawString()
                        print(toneName)
                        print(toneScore)
//                        switch toneName {
//                        case "Anger":
//                            self.angerLabel.text = "Anger: \(toneScore ?? "0")"
//                        case "Fear":
//                            self.fearLabel.text = "Fear: \(toneScore ?? "0")"
//                        case "Joy":
//                            self.joyLabel.text = "Joy: \(toneScore ?? "0")"
//                        case "Sadness":
//                            self.sadnessLabel.text = "Sadness: \(toneScore ?? "0")"
//                        default:
//                            break
//                        }
                    }

                    

                    
                case.failure(let error):
                    print(error.localizedDescription)
                    //ProgressHUD.showError(error.localizedDescription)
                }
        }
    }
}

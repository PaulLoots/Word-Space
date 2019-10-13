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
import EFCountingLabel
import NVActivityIndicatorView

class ScoreBoardViewController: UIViewController {

    //Player Data
    var enteredSentence = "I am super happy"
    var answerTime = 0
    var playerScore = 0
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var scoreLabel: EFCountingLabel!
    @IBOutlet weak var wordBubble: UIView!
    
    //Score
    @IBOutlet weak var scoreRing: UICircularProgressRing!
    @IBOutlet weak var scoreLoadingView: NVActivityIndicatorView!
    
    //Colour
     var accentColour = "Purple-Accent"
     var backgroundColour = "Purple-Background"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sentenceLabel.text = enteredSentence
        scoreLoadingView.startAnimating()
        animateIn()
        getToneValue(sentenceString:enteredSentence)
    }
    
    func calculateScore(angerValue: Float, fearValue: Float, joyValue: Float, sadnessValue: Float) {
        var score: Float = 0
        // TODO: - Replace with DB value
        let currentEmotion = "joy"
        switch currentEmotion {
        case "anger":
            score = angerValue - fearValue - joyValue - sadnessValue
        case "fear":
            score = fearValue - angerValue - joyValue - sadnessValue
        case "joy":
            score = joyValue - fearValue - angerValue - sadnessValue
        case "sadness":
            score = sadnessValue - fearValue - joyValue - angerValue
        default:
            break
        }
        score = Float((Double(answerTime) * 0.01) + (Double(score) * 0.9))
        playerScore = Int(score * 10000)
        displayScore()
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
                    var angerVaue: Float = 0.0
                    var fearVaue: Float = 0.0
                    var joyVaue: Float = 0.0
                    var sadnessVaue: Float = 0.0
                    
                    for n in 0...4 {
                        //print(json["document_tone"]["tone_categories"][0]["tones"])
                        let toneName = json["document_tone"]["tone_categories"][0]["tones"][n]["tone_name"].rawString()
                        let toneScore = json["document_tone"]["tone_categories"][0]["tones"][n]["score"].rawString()
                        switch toneName {
                        case "Anger":
                            angerVaue = (toneScore as NSString?)?.floatValue ?? 0
                        case "Fear":
                            fearVaue = (toneScore as NSString?)?.floatValue ?? 0
                        case "Joy":
                            joyVaue = (toneScore as NSString?)?.floatValue ?? 0
                        case "Sadness":
                            sadnessVaue = (toneScore as NSString?)?.floatValue ?? 0
                        default:
                            break
                        }
                    }
                    self.calculateScore(angerValue: angerVaue, fearValue: fearVaue, joyValue: joyVaue, sadnessValue: sadnessVaue)
                    
                case.failure(let error):
                    print(error.localizedDescription)
                    //ProgressHUD.showError(error.localizedDescription)
                }
        }
    }
    
    // MARK: - Animations
    
    func animateIn() {
        wordBubble.transform = .init(translationX: -50, y: 0)
        wordBubble.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.wordBubble.transform = .identity
                self.wordBubble.alpha = 1
            })
        }
    }
    
    func displayScore() {
        scoreLoadingView.stopAnimating()
        scoreRing.isHidden = false
        
        scoreLabel.setUpdateBlock { value, label in
            let intValue = Int(value)
            label.text = intValue.formattedWithSeparator
        }
        scoreLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 2)
        scoreLabel.countFrom(0, to: CGFloat(playerScore) , withDuration: 1.5)
        
        scoreRing.animationTimingFunction = .easeOut
        if playerScore < 0 {
            let score = -playerScore
            scoreRing.isClockwise = false
            scoreRing.startProgress(to: CGFloat(score/100), duration: 1.5)
        } else {
            scoreRing.startProgress(to: CGFloat(playerScore/100), duration: 1.5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.scoreLabel.transform = .init(scaleX: 1.2, y: 1.2)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.scoreLabel.transform = .identity
            })
        }
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

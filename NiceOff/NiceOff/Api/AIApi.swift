//
//  AIApi.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/22.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

class AIApi {

    func getToneValue(catagory: String, sentenceString: String, onSuccess: @escaping(ToneResponse) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        guard let correctedSentence = sentenceString.addingPercentEncoding(withAllowedCharacters: .symbols) else {
        print("Error. cannot cast name into String")
        onError("Error. cannot cast name into String")
        return
        }
        
        let apiKey = "Qa2dXZ3ZDFZ-uMFmjsu3TJIQMnel0GJFIUNGgCAkwkn0"
        let urlString = "https://gateway-lon.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19&sentences=false&text=\(correctedSentence)"
        
        let url = URL(string: urlString)
        
        Alamofire.request(url!)
        .authenticate(user: "apiKey", password: apiKey)
            .responseJSON { (response) in
                switch response.result {
                case.success(let value):
                    let json = JSON(value)
                    var angerVaue: Float = 0.0
                    var fearVaue: Float = 0.0
                    var joyVaue: Float = 0.0
                    var sadnessVaue: Float = 0.0
                    
                    for n in 0...4 {
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
  
                    onSuccess(ToneResponse(word: sentenceString, catagory: catagory, angerValue: angerVaue, fearValue: fearVaue, joyValue: joyVaue, sadnessValue: sadnessVaue))
                    
                case.failure(let error):
                    print(error.localizedDescription)
                    onError(error.localizedDescription)
                }
        }
    }
}

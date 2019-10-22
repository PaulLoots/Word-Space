//
//  AddWordsViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/21.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddWordsViewController: UIViewController {

    //Backgrounds
    @IBOutlet var subjectViewBackground: DesignableView!
    @IBOutlet var verbViewBackground: DesignableView!
    @IBOutlet var objectViewBackground: DesignableView!
    @IBOutlet var adjectiveViewBackground: DesignableView!
    @IBOutlet var adverbViewBackground: DesignableView!
    
    //Enter Word View
    @IBOutlet var enterWordView: UIView!
    @IBOutlet var wordInput: DesignableTextField!
    @IBOutlet var submitWordButton: DesignableButton!
    @IBOutlet var exampleText: UILabel!
    @IBOutlet var descriptonText: UILabel!
    @IBOutlet var noun: UILabel!
    @IBOutlet var wordtypeLabel: UILabel!
    @IBOutlet var enterWordFrame: DesignableView!
    @IBOutlet var symboldErrorLabel: UILabel!
    @IBOutlet var submitLoadingView: NVActivityIndicatorView!
    @IBOutlet var addingSuccessIcon: UIImageView!
    
    //Secret View
    @IBOutlet var enterSecretViewContainer: UIView!
    @IBOutlet var enterSecretButton: DesignableButton!
    @IBOutlet var wordLabel: DesignableTextField!
    
    //Word Type
    var currentWordType = ""
    
    //Colour
    var accentColour = "Purple-Accent"
    var backgroundColour = "Purple-Background"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }
    
    @IBAction func backSwipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setTheme() {
        view.tintColor = UIColor.init(named: accentColour)
        view.backgroundColor = UIColor.init(named: backgroundColour)
        submitWordButton.backgroundColor = UIColor.init(named: self.accentColour)
        exampleText.textColor = UIColor.init(named: self.accentColour)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviewSegue" {
            if let ReviewController = segue.destination as? ReviewViewController {
                ReviewController.accentColour = accentColour
                ReviewController.backgroundColour = backgroundColour
            }
        }
    }
    
    // MARK: - Enter Word
    
    func showEnterWordOverlay(wordType: String, exampleText: String, descriptionText: String) {
        self.view.addSubview(enterWordView)
        enterWordView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.enterWordView.tintColor = UIColor.init(named: self.accentColour)
        self.wordtypeLabel.text = wordType
        self.exampleText.textColor = UIColor.init(named: self.accentColour)
        self.exampleText.text = exampleText
        self.descriptonText.text = descriptionText
        if wordType == "Subject" || wordType == "Object" {
            noun.isHidden = false
        } else {
            noun.isHidden = true
        }
        self.enterWordFrame.transform = .init(scaleX: 0.6, y: 0)
        self.wordInput.text = ""
        self.wordInput.becomeFirstResponder()
        self.enterWordView.alpha = 0
        self.submitWordButton.isHidden = false
        self.wordInput.isHidden = false
        self.addingSuccessIcon.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.enterWordView.alpha = 1
            })
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.enterWordFrame.transform = .identity
            })
        }
    }
    
    func hideEnterWordOverlay() {
        submitWordButton.setTitle("Submit", for: .normal)
        submitWordButton.isEnabled = true
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.enterWordFrame.transform = .init(scaleX: 0.3, y: 0.3)
            self.enterWordView.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.enterWordFrame.transform = .identity
            self.enterWordView.removeFromSuperview()
        }
    }
    
    @IBAction func onCloseTapped(_ sender: Any) {
        hideEnterWordOverlay()
    }
    
    @IBAction func onSubmitWordTapped(_ sender: Any) {
        if var word = wordInput.text {
            
            //TODO: - Check if word is already added to database
            
            symboldErrorLabel.isHidden = true
            let symbols: [Character] = ["!","?",".","!"]
            if symbols.contains(where: word.contains) {
                symboldErrorLabel.isHidden = false
            } else {
                if word.last == " " {
                    word = String(word.dropLast())
                }
                submitWordButton.setTitle("", for: .normal)
                submitWordButton.isEnabled = false
                addSuggestedWord(word: SuggestedWord(word: word, type: currentWordType))
            }
        }
    }
    
    // MARK: - Sentence type buttons
    
    //Subject
    @IBAction func onNewSubjectDown(_ sender: Any) {
        animateDown(currentView: subjectViewBackground)
    }
    @IBAction func onNewSubjectCancel(_ sender: Any) {
        animateUp(currentView: subjectViewBackground)
    }
    @IBAction func onNewSubjectUp(_ sender: Any) {
        animateUp(currentView: subjectViewBackground)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.currentWordType = "Subject"
            self.showEnterWordOverlay(wordType: "Subject", exampleText: "alien", descriptionText: "who or what does the action")
        }
    }
    
    //Verb
    @IBAction func onNewVerbDown(_ sender: Any) {
        animateDown(currentView: verbViewBackground)
    }
    @IBAction func onNewVerbCancel(_ sender: Any) {
        animateUp(currentView: verbViewBackground)
    }
    @IBAction func onNewVerbUp(_ sender: Any) {
        animateUp(currentView: verbViewBackground)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.currentWordType = "Verb"
            self.showEnterWordOverlay(wordType: "Verb", exampleText: "abducts", descriptionText: "what is the action")
        }
    }
    
    //Object
    @IBAction func onNewObjectDown(_ sender: Any) {
        animateDown(currentView: objectViewBackground)
    }
    @IBAction func onNewObjectCancel(_ sender: Any) {
        animateUp(currentView: objectViewBackground)
    }
    @IBAction func onNewObjectUp(_ sender: Any) {
        animateUp(currentView: objectViewBackground)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.currentWordType = "Object"
            self.showEnterWordOverlay(wordType: "Object", exampleText: "cow", descriptionText: "what is affected by the action")
        }
    }
    
    //Adjective
    @IBAction func onNewAdjectiveDown(_ sender: Any) {
        animateDown(currentView: adjectiveViewBackground)
    }
    @IBAction func onNewAdjectiveCancel(_ sender: Any) {
        animateUp(currentView: adjectiveViewBackground)
    }
    @IBAction func onNewAdjectiveUp(_ sender: Any) {
        animateUp(currentView: adjectiveViewBackground)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.currentWordType = "Adjective"
            self.showEnterWordOverlay(wordType: "Adjective", exampleText: "curious", descriptionText: "describes the subject & object")
        }
    }
    
    //Adverb
    @IBAction func onNewAdverbDown(_ sender: Any) {
        animateDown(currentView: adverbViewBackground)
    }
    @IBAction func onNewAdverbCancel(_ sender: Any) {
        animateUp(currentView: adverbViewBackground)
    }
    @IBAction func onNewAdverbUp(_ sender: Any) {
        animateUp(currentView: adverbViewBackground)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.currentWordType = "Adverb"
            self.showEnterWordOverlay(wordType: "Adverb", exampleText: "quietly", descriptionText: "describes the verb")
        }
    }
    
    // MARK: - Review Secret
    
    func showEnterSecretOverlay() {
        self.view.addSubview(enterSecretViewContainer)
        enterSecretViewContainer.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.enterSecretViewContainer.tintColor = UIColor.init(named: self.accentColour)
        self.enterSecretButton.backgroundColor = UIColor.init(named: self.accentColour)
        self.wordLabel.transform = .init(scaleX: 0.3, y: 0.3)
        self.wordLabel.text = ""
        self.wordLabel.becomeFirstResponder()
        self.enterSecretViewContainer.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.enterSecretViewContainer.transform = .identity
                self.enterSecretViewContainer.alpha = 1
                self.wordLabel.transform = .identity
            })
        }
    }
    
    func hideEnterSecretOverlay() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.wordLabel.transform = .init(scaleX: 0.4, y: 0.4)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.enterSecretViewContainer.transform = .identity
            self.wordLabel.transform = .identity
            self.enterSecretViewContainer.removeFromSuperview()
        }
    }
    
    @IBAction func onReviewLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            showEnterSecretOverlay()
        }
    }
    
    @IBAction func secretButtonTapped(_ sender: Any) {
        if wordLabel.text == "7323" {
            performSegue(withIdentifier: "toReviewSegue", sender: nil)
        }
    }
    
    @IBAction func closeSecretTapped(_ sender: Any) {
        hideEnterSecretOverlay()
    }
    
    // MARK: - Animations
    
    func animateDown(currentView: DesignableView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            currentView.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            currentView.shadowRadius = 0
            currentView.shadowOpacity = 0
        })
    }
    
    func animateUp(currentView: DesignableView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            currentView.transform = CGAffineTransform.identity
            currentView.shadowRadius = 6
            currentView.shadowOpacity = 1
        })
    }
    
    // MARK: - Api
    
    func addSuggestedWord(word: SuggestedWord) {
        wordInput.endEditing(true)
        submitLoadingView.startAnimating()
        let documentData = [
            WORD_TEXT: word.word.lowercased(),
            WORD_TYPE: word.type
            ] as [String : Any]
        
        Api.Word.addSuggestedWord(documentData: documentData, onSuccess: {
            self.submitLoadingView.stopAnimating()
            self.submitWordButton.isHidden = true
            self.wordInput.isHidden = true
            self.addingSuccessIcon.isHidden = false
            self.addingSuccessIcon.transform = .init(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.addingSuccessIcon.transform = .identity
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.hideEnterWordOverlay()
            }
        }, onError: {error in print(error)})
    }

}

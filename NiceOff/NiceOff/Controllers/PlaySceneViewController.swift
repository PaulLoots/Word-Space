//
//  PlaySceneViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/08.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit

class PlaySceneViewController: UIViewController {

    //New Round
    @IBOutlet var newRoundView: UIView!
    
    //In Game
    @IBOutlet var gameView: UIView!
    @IBOutlet var selectedSentenceCollectionView: UICollectionView!
    @IBOutlet var wordOptionsCollectionView: UICollectionView!
    var wordOptionsAdded : Array<QuestionSentenceItem> = []
    var wordOptions : Array<String> = passPhrase.shuffled()
    var currentSelectingIndexPath = 0
    @IBOutlet var enterButton: DesignableButton!
    @IBOutlet var timerLabel: UILabel!
    var countDownSeconds = 10
    var timer = Timer()
    
    //Colour
    var accentColour = "Purple-Accent"
    var backgroundColour = "Purple-Background"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Collection View
        selectedSentenceCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        selectedSentenceCollectionView.register(UINib(nibName: "BareWordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BareWordCollectionViewCell")
        wordOptionsCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        
        initialiseGame()
    }
    
    func initialiseGame() {
        
        generateQuestionSentence()
        timerLabel.text = String(countDownSeconds)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startTimer()
            self.animateBeginRound()
        }
    }
    
    // MARK: - Submit Sentence
    
    @IBAction func onEnterTapped(_ sender: Any) {
        if checkIfSentenceIsValid() {
            performSegue(withIdentifier: "submitAnswerSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitAnswerSegue" {
                if let ScoreBoardViewController = segue.destination as? ScoreBoardViewController {
                    ScoreBoardViewController.enteredSentence = mergeSelectionIntoSentence()
                    ScoreBoardViewController.answerTime = countDownSeconds
                }
            }
    }
    
    func mergeSelectionIntoSentence() -> String {
        var sentenceString = ""
        for wordOption in wordOptionsAdded {
            sentenceString = "\(sentenceString)\(wordOption.value)"
        }
        print("sentenceString*************")
        print(sentenceString)
        return sentenceString
    }
    
    func checkIfSentenceIsValid() -> Bool {
        var isValid = false
        for wordOption in wordOptionsAdded {
            enterButton.alpha = 0.5
            switch wordOption.value {
            case "SUBJECT":
                return false
            case "VERB":
                return false
            case "OBJECT":
                return false
            case "ADJECTIVE":
                return false
            case "ADVERB":
                return false
                
            default:
                enterButton.alpha = 1
                isValid = true
                break
            }
        }
        
        return isValid
    }
    
    // MARK: - Sentence Generating Algorithm
    
    func generateQuestionSentence() {
        let sentence = easySentenceStructures.randomElement() ?? "The *subject* *verb* a *object*."
        var isFirstType = true
        let sentenceComponentsArray = sentence.components(separatedBy: "*")
        
        for sentenceComponent in sentenceComponentsArray {
            switch sentenceComponent {
            case "subject":
                if isFirstType {
                    isFirstType = false
                    generateWords(editingType: "subject")
                    wordOptionsAdded.append(QuestionSentenceItem(value: "SUBJECT", type: "subject", isSelected: true, wordsList: self.wordOptions))
                    currentSelectingIndexPath = wordOptionsAdded.count - 1
                } else {
                    wordOptionsAdded.append(QuestionSentenceItem(value: "SUBJECT", type: "subject", isSelected: false, wordsList: []))
                }
                break
            case "verb":
                if isFirstType {
                    isFirstType = false
                    generateWords(editingType: "subject")
                    wordOptionsAdded.append(QuestionSentenceItem(value: "VERB", type: "verb", isSelected: true, wordsList: self.wordOptions))
                    currentSelectingIndexPath = wordOptionsAdded.count - 1
                } else {
                    wordOptionsAdded.append(QuestionSentenceItem(value: "VERB", type: "verb", isSelected: false, wordsList: []))
                }
                break
            case "object":
                if isFirstType {
                    isFirstType = false
                    generateWords(editingType: "object")
                    wordOptionsAdded.append(QuestionSentenceItem(value: "OBJECT", type: "object", isSelected: true, wordsList: self.wordOptions))
                    currentSelectingIndexPath = wordOptionsAdded.count - 1
                } else {
                    wordOptionsAdded.append(QuestionSentenceItem(value: "OBJECT", type: "object", isSelected: false, wordsList: []))
                }
                break
            case "adjective":
                if isFirstType {
                    isFirstType = false
                    generateWords(editingType: "adjective")
                    wordOptionsAdded.append(QuestionSentenceItem(value: "ADJECTIVE", type: "adjective", isSelected: true, wordsList: self.wordOptions))
                    currentSelectingIndexPath = wordOptionsAdded.count - 1
                } else {
                    wordOptionsAdded.append(QuestionSentenceItem(value: "ADJECTIVE", type: "adjective", isSelected: false, wordsList: []))
                }
                break
            case "adverb":
                if isFirstType {
                    isFirstType = false
                    generateWords(editingType: "adverb")
                    wordOptionsAdded.append(QuestionSentenceItem(value: "ADVERB", type: "adverb", isSelected: true, wordsList: self.wordOptions))
                    currentSelectingIndexPath = wordOptionsAdded.count - 1
                } else {
                    wordOptionsAdded.append(QuestionSentenceItem(value: "ADVERB", type: "adverb", isSelected: false, wordsList: []))
                }
                break
            default:
                wordOptionsAdded.append(QuestionSentenceItem(value: sentenceComponent, type: "structure", isSelected: false, wordsList: []))
            }
        }
        
        wordOptionsCollectionView.reloadData()
        selectedSentenceCollectionView.reloadData()
    }
    
    func setCurrentEditingType(editingIndex: IndexPath) {
        for (index, _) in wordOptionsAdded.enumerated() {
            wordOptionsAdded[index].isSelected = false
        }
        
        wordOptionsAdded[editingIndex.item].isSelected = true
        
        if wordOptionsAdded[editingIndex.item].wordsList.count == 0 {
            generateWords(editingType: wordOptionsAdded[editingIndex.item].type)
            wordOptionsAdded[editingIndex.item].wordsList = self.wordOptions
        } else {
            self.wordOptions = wordOptionsAdded[editingIndex.item].wordsList
        }
        
        currentSelectingIndexPath = editingIndex.item
        animateTypeChange()
        self.selectedSentenceCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.wordOptionsCollectionView.reloadData()
        }
    }
    
    // MARK: - Word Generating Algorithm
    
    func generateWords(editingType: String) {
        var looking = true
        var wordsList: [String] = []
        
        switch editingType {
        case "subject":
            while looking {
                let randomWord = nouns.randomElement() ?? "dog"
                if !wordsList.contains(randomWord) {
                    wordsList.append(randomWord)
                    if !checkWordsListLength(wordsList: wordsList) {
                        looking = false
                    }
                }
            }
            break
        case "verb":
            while looking {
                let randomWord = verbs.randomElement() ?? "dog"
                if !wordsList.contains(randomWord) {
                    wordsList.append(randomWord)
                    if !checkWordsListLength(wordsList: wordsList) {
                        looking = false
                    }
                }
            }
            break
        case "object":
            while looking {
                let randomWord = nouns.randomElement() ?? "dog"
                if !wordsList.contains(randomWord) {
                    wordsList.append(randomWord)
                    if !checkWordsListLength(wordsList: wordsList) {
                        looking = false
                    }
                }
            }
            break
        case "adjective":
            while looking {
                let randomWord = adjectives.randomElement() ?? "dog"
                if !wordsList.contains(randomWord) {
                    wordsList.append(randomWord)
                    if !checkWordsListLength(wordsList: wordsList) {
                        looking = false
                    }
                }
            }
            break
        case "adverb":
            while looking {
                let randomWord = nouns.randomElement() ?? "dog"
                if !wordsList.contains(randomWord) {
                    wordsList.append(randomWord)
                    if !checkWordsListLength(wordsList: wordsList) {
                        looking = false
                    }
                }
            }
            break
        default:
            break
        }
        
        self.wordOptions = wordsList
    }
    
    func checkWordsListLength(wordsList:Array<String>) -> Bool {
        var characterCount = 0
        let wordCount = wordsList.count
        
        for word in wordsList {
            characterCount = word.count
        }
        
        let totalCount = characterCount + (wordCount * 5)
        
        if totalCount > 80 {
            return false
        } else {
            return true
        }
    }
    
    func isValueGivenToType(value: String) -> Bool {
        switch value {
            case "SUBJECT":
                return false
            case "VERB":
                return false
            case "OBJECT":
                return false
            case "ADJECTIVE":
                return false
            case "ADVERB":
                return false
            default:
                return true
        }
    }
    
    // MARK: - Countdown Timer
    
    func startTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        countDownSeconds -= 1
        timerLabel.text = String(countDownSeconds)
        
        if countDownSeconds < 5 {
            bounceTimerLabel()
        }
        
        if countDownSeconds < 1 {
            timer.invalidate()
            for (index, option) in wordOptionsAdded.enumerated() {
                if !isValueGivenToType(value: option.value) {
                    switch option.value {
                        case "SUBJECT":
                            wordOptionsAdded[index].value = nouns.randomElement() ?? "dog"
                            break
                        case "VERB":
                            wordOptionsAdded[index].value = verbs.randomElement() ?? "barks"
                            break
                        case "OBJECT":
                            wordOptionsAdded[index].value = nouns.randomElement() ?? "dog"
                            break
                        case "ADJECTIVE":
                            wordOptionsAdded[index].value = adjectives.randomElement() ?? "very"
                            break
                        case "ADVERB":
                            wordOptionsAdded[index].value = adverbs.randomElement() ?? "loudly"
                            break
                        default:
                            break
                    }
                }
            }
            selectedSentenceCollectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.performSegue(withIdentifier: "submitAnswerSegue", sender: nil)
            }
        }
    }
    
    // MARK: - Animations
    
    func animateBeginRound() {
        self.gameView.transform = .init(translationX: 0, y: 100)
        self.gameView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
             self.newRoundView.transform = .init(translationX: 0, y: -100)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.gameView.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
             self.newRoundView.alpha = 0
             self.gameView.alpha = 1
            })
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.gameView.transform = .identity
            })
        }
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
             self.newRoundView.isHidden = true
         }
    }
    
    func animateTypeChange() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.wordOptionsCollectionView.transform = .init(scaleX: 0.8, y: 0.8)
            self.wordOptionsCollectionView.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,  options: .curveEaseInOut, animations: {
                self.wordOptionsCollectionView.transform = .identity
                self.wordOptionsCollectionView.alpha = 1
            })
        }
    }
    
    func bounceTimerLabel() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.timerLabel.transform = .init(scaleX: 1.2, y: 1.2)
            self.timerLabel.textColor = UIColor.init(named: self.accentColour)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.timerLabel.transform = .identity
                self.timerLabel.textColor = UIColor.init(named: "Text-Primary")
            })
        }
    }
}

// MARK: - Collection View Delegates

extension PlaySceneViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.selectedSentenceCollectionView {
            return wordOptionsAdded.count
        } else if collectionView == self.wordOptionsCollectionView {
            return wordOptions.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.selectedSentenceCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            if wordOptionsAdded[indexPath.item].type == "structure" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BareWordCollectionViewCell", for: indexPath) as! BareWordCollectionViewCell
                cell.bareWordLabel.text = wordOptionsAdded[indexPath.item].value
                return cell
            } else {
                if wordOptionsAdded[indexPath.item].isSelected {
                    cell.pillBackground.backgroundColor = UIColor.init(named: "Overlay-Background")
                    cell.pillBackground.borderWidth = 2
                    cell.pillBackground.borderColor = UIColor.init(named: accentColour)
                    cell.pillWord.textColor = UIColor.init(named: accentColour)
                    cell.pillWord.font = UIFont(name:"SourceSansPro-Bold", size: 12.0)
                    cell.pillWord.text = wordOptionsAdded[indexPath.item].value
                } else {
                    cell.pillBackground.backgroundColor = UIColor.init(named: "Overlay-Background")
                    cell.pillBackground.borderWidth = 0
                    cell.pillWord.textColor = UIColor.init(named: "Text-Grey")
                    cell.pillWord.font = UIFont(name:"SourceSansPro-Bold", size: 12.0)
                    cell.pillWord.text = wordOptionsAdded[indexPath.item].value
                }
                if isValueGivenToType(value: wordOptionsAdded[indexPath.item].value) {
                    cell.pillBackground.backgroundColor = UIColor.init(named: "Card-Neutral")
                    cell.pillWord.textColor = UIColor.init(named: "Text-Primary")
                    cell.pillWord.font = UIFont(name:"SourceSansPro-Regular", size: 17.0)
                }
            }
            return cell
        } else if collectionView == self.wordOptionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            cell.pillWord.text = wordOptions[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if collectionView == self.selectedSentenceCollectionView {
                if let cell = collectionView.cellForItem(at: indexPath) as? WordPillCollectionViewCell {
                    cell.pillBackground.transform = .init(scaleX: 0.8, y: 0.8)
                }
            } else if collectionView == self.wordOptionsCollectionView {
                if let cell = collectionView.cellForItem(at: indexPath) as? WordPillCollectionViewCell {
                    cell.pillBackground.transform = .init(scaleX: 0.8, y: 0.8)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.1) {
                if let cell = collectionView.cellForItem(at: indexPath) as? WordPillCollectionViewCell {
                    cell.pillBackground.transform = .identity
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if collectionView == self.selectedSentenceCollectionView {
                self.setCurrentEditingType(editingIndex: indexPath)
            } else if collectionView == self.wordOptionsCollectionView {
                self.wordOptionsAdded[self.currentSelectingIndexPath].value = self.wordOptions[indexPath.item]
                _ = self.checkIfSentenceIsValid()
                self.selectedSentenceCollectionView.reloadData()
            }
        }
    }
}

extension PlaySceneViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.selectedSentenceCollectionView {
            guard let cell: WordPillCollectionViewCell = Bundle.main.loadNibNamed("WordPillCollectionViewCell",
                                                                          owner: self,
                                                                          options: nil)?.first as? WordPillCollectionViewCell else { return CGSize.zero }
            if wordOptionsAdded[indexPath.item].type == "structure" {
                cell.pillWord.text = wordOptionsAdded[indexPath.item].value
                cell.pillWord.font = UIFont(name:"SourceSansPro-SemiBold", size: 20.0)
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                if wordOptionsAdded[indexPath.item].value == " " {
                    return CGSize(width: size.width - 28, height: 42)
                } else {
                    return CGSize(width: size.width - 24, height: 42)
                }
            } else {
                if isValueGivenToType(value: wordOptionsAdded[indexPath.item].value) {
                    cell.pillWord.text = wordOptionsAdded[indexPath.item].value
                    cell.setNeedsLayout()
                    cell.layoutIfNeeded()
                    let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    return CGSize(width: size.width, height: 42)
                } else {
                    return CGSize(width: 110, height: 42)
                }
            }
        } else if collectionView == self.wordOptionsCollectionView {
            guard let cell: WordPillCollectionViewCell = Bundle.main.loadNibNamed("WordPillCollectionViewCell",
                                                                          owner: self,
                                                                          options: nil)?.first as? WordPillCollectionViewCell else { return CGSize.zero }
            cell.pillWord.text = wordOptions[indexPath.item]
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 42)
        } else {
            return CGSize(width: 42, height: 42)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.selectedSentenceCollectionView {
            return 9
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

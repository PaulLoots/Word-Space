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
    var wordOptionsAdded : Array<String> = ["hi"]
    var wordOptions : Array<String> = passPhrase.shuffled()
    
    //Colour
    var accentColour = "Purple-Accent"
    var backgroundColour = "Purple-Background"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Collection View
        selectedSentenceCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        wordOptionsCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        
        initialiseGame()
    }
    
    func initialiseGame() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animateBeginRound()
        }
    }
    
    @IBAction func onEnterTapped(_ sender: Any) {
        performSegue(withIdentifier: "submitAnswerSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitAnswerSegue" {
                if let ScoreBoardViewController = segue.destination as? ScoreBoardViewController {
                    ScoreBoardViewController.enteredSentence = mergeSelectionIntoSentence()
                }
            }
    }
    
    func mergeSelectionIntoSentence() -> String {
        var sentenceString = ""
        for wordOption in wordOptionsAdded {
            sentenceString = "\(sentenceString) \(wordOption)"
        }
        return sentenceString
    }
    
    // MARK: - Word Generating Algorithm
    
    func generateWords() {
        var wordsList: Array<String> = []
        
        //Determiners
        wordsList.append(determinersCommon.randomElement() ?? "the")
        let determinerChance = Int.random(in: 0 ... 10)
        //if determinerChance
    }
    
    func checkWordsListLength(wordsList:Array<String>) -> Bool {
        var characterCount = 0
        let wordCount = wordsList.count
        
        for word in wordsList {
            characterCount = word.count
        }
        
        let totalCount = characterCount + (wordCount * 5)
        
        if totalCount > 100 {
            return false
        } else {
            return true
        }
    }
    
    //Animations
    
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
            cell.pillWord.text = wordOptionsAdded[indexPath.item]
            return cell
        } else if collectionView == self.wordOptionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            
            if wordOptionsAdded.contains(wordOptions[indexPath.item]) {
                cell.pillBackground.backgroundColor = UIColor.init(named: "Overlay-Background")
                cell.pillWord.text = ""
            } else {
                cell.pillBackground.backgroundColor = UIColor.init(named: "White")
                cell.pillWord.text = wordOptions[indexPath.item]
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? WordPillCollectionViewCell {
                cell.pillBackground.transform = .init(scaleX: 0.8, y: 0.8)
                //cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? WordPillCollectionViewCell {
                cell.pillBackground.transform = .identity
                //cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if collectionView == self.selectedSentenceCollectionView {
                for n in 0...(self.wordOptionsAdded.count - 1) {
                    if n >= indexPath.item && n < self.wordOptionsAdded.count - 1 {
                        self.wordOptionsAdded[n] = self.wordOptionsAdded[n + 1]
                    }
                }
                self.wordOptionsAdded.remove(at: self.wordOptionsAdded.count - 1)
                
                self.wordOptionsCollectionView.reloadData()
                self.selectedSentenceCollectionView.reloadData()
                
            } else if collectionView == self.wordOptionsCollectionView {
                if !self.wordOptionsAdded.contains(self.wordOptions[indexPath.item]) {
                    self.wordOptionsAdded.append(self.wordOptions[indexPath.item])
                    self.wordOptionsCollectionView.reloadData()
                    self.selectedSentenceCollectionView.reloadData()
                }
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
                                                                          options: nil)?.first as? WordPillCollectionViewCell else {
                return CGSize.zero
            }
            cell.pillWord.text = wordOptionsAdded[indexPath.item]
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            print(size)
            return CGSize(width: size.width, height: 42)
        } else if collectionView == self.wordOptionsCollectionView {
                    guard let cell: WordPillCollectionViewCell = Bundle.main.loadNibNamed("WordPillCollectionViewCell",
                                                                          owner: self,
                                                                          options: nil)?.first as? WordPillCollectionViewCell else {
                return CGSize.zero
            }
            cell.pillWord.text = wordOptions[indexPath.item]
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            print(size)
            return CGSize(width: size.width, height: 42)
        } else {
            return CGSize(width: 42, height: 42)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

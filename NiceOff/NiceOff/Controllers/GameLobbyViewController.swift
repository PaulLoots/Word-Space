//
//  GameLobbyViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/29.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit

class GameLobbyViewController: UIViewController {

    @IBOutlet var passPhraseCollectionView: UICollectionView!
    @IBOutlet var passPhraseOptionsCollectionView: UICollectionView!
    
    //Pass Phrase
    var passPhraseItems : Array<String> = []
    var passPhraseOptions : Array<String> = ["indespensable","looky", "i","lol","hi","Longer word", "i", "more spech", "word", "haha"]
    @IBOutlet var passPhraseLimitLabel: UILabel!
    @IBOutlet var setPhraseButton: DesignableButton!
    
    //Colour
    var accentColour = "Purple-Accent"
    var backgroundColour = "Purple-Background"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Collection View
        passPhraseCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        passPhraseOptionsCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: {

        })
    }
    
    //Pass Phrase Animation
    func shakeLimitLabel() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.passPhraseLimitLabel.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.passPhraseLimitLabel.transform = CGAffineTransform.identity
            })
        }
    }
    
    func checkPassPhraseCount() -> Bool {
        if passPhraseItems.count == 4 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.setPhraseButton.backgroundColor = UIColor.init(named: self.accentColour)
                self.setPhraseButton.alpha = 1
            })
            
            return true
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.setPhraseButton.backgroundColor = UIColor.init(named: "Card-Shadow")
                self.setPhraseButton.alpha = 0.5
            })
            
            return false
        }
    }
    
    @IBAction func onSetPhraseTapped(_ sender: Any) {
        if checkPassPhraseCount() {

        } else {
           shakeLimitLabel()
        }
    }
}

extension GameLobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.passPhraseCollectionView {
            return passPhraseItems.count
        } else if collectionView == self.passPhraseOptionsCollectionView {
            return passPhraseOptions.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.passPhraseCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            cell.pillWord.text = passPhraseItems[indexPath.item]
            return cell
        } else if collectionView == self.passPhraseOptionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            
            if passPhraseItems.contains(passPhraseOptions[indexPath.item]) {
                cell.pillBackground.backgroundColor = UIColor.init(named: "Overlay-Background")
                cell.pillWord.text = ""
            } else {
                cell.pillBackground.backgroundColor = UIColor.init(named: "White")
                cell.pillWord.text = passPhraseOptions[indexPath.item]
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
            if collectionView == self.passPhraseCollectionView {
                for n in 0...(self.passPhraseItems.count - 1) {
                    if n >= indexPath.item && n < self.passPhraseItems.count - 1 {
                        self.passPhraseItems[n] = self.passPhraseItems[n + 1]
                    }
                }
                self.passPhraseItems.remove(at: self.passPhraseItems.count - 1)
                self.passPhraseLimitLabel.text = String(self.passPhraseItems.count) + "/4"
                
                self.passPhraseOptionsCollectionView.reloadData()
                self.passPhraseCollectionView.reloadData()
                
            } else if collectionView == self.passPhraseOptionsCollectionView {
                if !self.passPhraseItems.contains(self.passPhraseOptions[indexPath.item]) {
                    if self.passPhraseItems.count < 4 {
                        self.passPhraseItems.append(self.passPhraseOptions[indexPath.item])
                        self.passPhraseOptionsCollectionView.reloadData()
                        self.passPhraseCollectionView.reloadData()
                    } else {
                        self.shakeLimitLabel()
                    }
                    self.passPhraseLimitLabel.text = String(self.passPhraseItems.count) + "/4"
                }
            }
            let _ = self.checkPassPhraseCount()
        }
    }
}

extension GameLobbyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.passPhraseCollectionView {
                    guard let cell: WordPillCollectionViewCell = Bundle.main.loadNibNamed("WordPillCollectionViewCell",
                                                                          owner: self,
                                                                          options: nil)?.first as? WordPillCollectionViewCell else {
                return CGSize.zero
            }
            cell.pillWord.text = passPhraseItems[indexPath.item]
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            print(size)
            return CGSize(width: size.width, height: 42)
        } else if collectionView == self.passPhraseOptionsCollectionView {
                    guard let cell: WordPillCollectionViewCell = Bundle.main.loadNibNamed("WordPillCollectionViewCell",
                                                                          owner: self,
                                                                          options: nil)?.first as? WordPillCollectionViewCell else {
                return CGSize.zero
            }
            cell.pillWord.text = passPhraseOptions[indexPath.item]
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

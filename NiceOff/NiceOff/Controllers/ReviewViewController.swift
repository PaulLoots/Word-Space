//
//  ReviewViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/21.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReviewViewController: UIViewController {

    //Haptics
    let impact = UIImpactFeedbackGenerator()
    let notificationTap = UINotificationFeedbackGenerator()
    let selectionTap = UISelectionFeedbackGenerator()
    var setSelectionTap = true
    
    //Views
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var dislikeImageView: UIImageView!
    @IBOutlet var controlBarView: UIView!
    @IBOutlet var loadingIndicatorView: NVActivityIndicatorView!
    
    //Card Var
    var cardCenter = CGPoint()
    var buttonsEnabled = true
    @IBOutlet var card: DesignableView!
    @IBOutlet var cardSecond: DesignableView!
    @IBOutlet var cardThird: DesignableView!
    @IBOutlet var cardSecondOverlay: UIView!
    @IBOutlet var cardOverlay: UIView!
    var cardDeckData: Array<SuggestedWord> = []
    var topCardData: SuggestedWord!
    var secondCardData: SuggestedWord!
    var isCardFirst = true
    
    //Card Data
    @IBOutlet var cardWord: UILabel!
    @IBOutlet var cardSubject: UILabel!
    @IBOutlet var secondCardWord: UILabel!
    @IBOutlet var secondCardSubject: UILabel!
    
    
    //Colour
    var accentColour = "Purple-Accent"
    var backgroundColour = "Purple-Background"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDeck()
    }
    
    //MARK: - Card Movement
    
       @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
            let card = sender.view!
            let xFromCenter = card.center.x - cardCenter.x
            
            if sender.state == UIGestureRecognizer.State.began {
                cardCenter = card.center
                setSelectionTap = true
            }
            
            let point = sender.translation(in: view)
            card.center = CGPoint(x: cardCenter.x + point.x, y: cardCenter.y + point.y)
            
            let transformFactor  = 1 + abs(xFromCenter) / cardCenter.x

            if xFromCenter > 0 {
                likeImageView.transform = CGAffineTransform(scaleX: transformFactor, y: transformFactor)
                if card.center.x > view.frame.width - (view.frame.width / 6) {
                   //haptics
                    if setSelectionTap {
                        setSelectionTap = false
                        selectionTap.selectionChanged()
                    }
                   
                   likeImageView.tintColor = UIColor(named:accentColour)
                } else {
                   setSelectionTap = true
                   likeImageView.tintColor = UIColor(named: "Text-Primary")
                }
            } else if xFromCenter < 0 {
                dislikeImageView.transform = CGAffineTransform(scaleX: transformFactor, y: transformFactor)
                if card.center.x < (view.frame.width / 6) {
                    //haptics
                    if setSelectionTap {
                        setSelectionTap = false
                        selectionTap.selectionChanged()
                    }
                    dislikeImageView.tintColor = UIColor(named:accentColour)
                } else {
                    setSelectionTap = true
                    dislikeImageView.tintColor = UIColor(named: "Text-Primary")
                }
            } else {
                dislikeImageView.transform = CGAffineTransform.identity
                likeImageView.transform = CGAffineTransform.identity
            }
            
            if sender.state == UIGestureRecognizer.State.cancelled{
                UIView.animate(withDuration: 0, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    card.center = self.cardCenter
                })
                resetActionButtons()
            }
            
            if sender.state == UIGestureRecognizer.State.ended{
                
                if card.center.x < (view.frame.width / 6) {
                    self.swipeDisLiked()
                    return
                } else if card.center.x > view.frame.width - (view.frame.width / 6){
                    self.swipeLiked()
                    return
                }
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    card.center = self.cardCenter
                })
                
                resetActionButtons()
            }
        }
    
    func resetActionButtons() {
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
            self.dislikeImageView.transform = CGAffineTransform.identity
            self.likeImageView.transform = CGAffineTransform.identity
            self.likeImageView.tintColor = UIColor(named: "Text-Primary")
            self.dislikeImageView.tintColor = UIColor(named: "Text-Primary")
        })
    }
    
    //MARK: - Apprive & Deny
    
    func swipeDisLiked() {
        notificationTap.notificationOccurred(.success)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.card.center = CGPoint(x: self.card.center.x - self.view.frame.width, y: self.card.center.y + 75)
            self.card.alpha = 0;
        })
        resetActionButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showNextCard()
        }
    }
    
    func swipeLiked() {
        notificationTap.notificationOccurred(.success)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.card.center = CGPoint(x: self.card.center.x + self.view.frame.width, y: self.card.center.y + 75)
            self.card.alpha = 0;
        })
        resetActionButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showNextCard()
        }
    }

    //MARK: - Next Card

    func showNextCard() {
        //move card to card second place
        card.isHidden = false;
        card.center = cardCenter;
        card.transform = CGAffineTransform(translationX: 0, y: -39).scaledBy(x: 0.92, y: 0.92)
        card.alpha = 1;
        cardOverlay.isHidden = false;
        cardOverlay.alpha = 0.5
        
        //move card second to card third place
        cardSecond.isHidden = false;
        cardSecond.transform = CGAffineTransform(translationX: 0, y: -26.5).scaledBy(x: 0.94, y: 0.94)
        cardSecondOverlay.backgroundColor = UIColor(named: backgroundColour)
        cardSecondOverlay.alpha = 0.8
        
        //move card third to back
        cardThird.isHidden = false;
        cardThird.transform = CGAffineTransform(translationX: 0, y: -20).scaledBy(x: 0.94, y: 0.94)
        cardThird.alpha = 0
        
        CheckDeckLength()
        
        //animate all cards to initial position
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.card.transform = CGAffineTransform.identity
            self.cardOverlay.alpha = 0
            
            self.cardSecond.transform = CGAffineTransform.identity
            self.cardSecondOverlay.backgroundColor = UIColor(named: self.backgroundColour)
            self.cardSecondOverlay.alpha = 0.5
            
            self.cardThird.transform = CGAffineTransform.identity
            self.cardThird.alpha = 0.2
        })
    }
    
    func setTwoCardsRemaining() {
        cardThird.isHidden = true;
    }
    
    func setOneCardRemaining() {
        cardThird.isHidden = true;
        cardSecond.isHidden = true;
    }
    
    func setNoCardsRemaining() {

        cardThird.isHidden = true;
        cardSecond.isHidden = true;
        card.isHidden = true;
        HideControlBar()
        
        //showCardsDonePane()
    }
    
    //MARK: - Control bar Functions
    
    func HideControlBar() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.controlBarView.transform = CGAffineTransform.init(translationX: 0, y: 100)
            self.controlBarView.alpha = 0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.controlBarView.isHidden = true;
        }
    }
    
    func ShowControlBar() {
        self.controlBarView.isHidden = false;
        self.controlBarView.transform = CGAffineTransform.init(translationX: 0, y: 100)
        self.controlBarView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.controlBarView.transform = CGAffineTransform.identity
            self.controlBarView.alpha = 1
        })
    }
    
    //MARK: - Deck
    
    func populateDeck() {
        SetDeckLoading()
        getSuggestedWords()
    }
    
    func CheckDeckLength() {
        if cardDeckData.count < 1 {
            //no cards left in deck
            setNoCardsRemaining()
        } else {
            topCardData = cardDeckData[0]
            if isCardFirst {
                self.isCardFirst = false
            } else {
                self.UpdateDeck()
            }
        }
    }
    
    func UpdateDeck() {

        //Visuals
        buttonsEnabled = true;
        //cardsDoneView.removeFromSuperview()

        if cardDeckData.count == 2 {
            //Only one card left in deck
            setTwoCardsRemaining()
            secondCardData = cardDeckData[1]
            secondCardWord.text = secondCardData.word
            secondCardSubject.text = secondCardData.type
        } else if cardDeckData.count < 2 {
            //Only one card left in deck
            setOneCardRemaining()
        } else {
            secondCardData = cardDeckData[1]
            secondCardWord.text = secondCardData.word
            secondCardSubject.text = secondCardData.type
        }
        cardDeckData.removeFirst()
        
        cardWord.text = topCardData.word
        cardSubject.text = topCardData.type
    }
    
    func SetDeckLoading() {
        loadingIndicatorView.startAnimating()
        HideControlBar()
        self.cardOverlay.isHidden = true
        card.isHidden = true;
        cardSecond.isHidden = true;
        cardThird.isHidden = true;
    }
    
    func ShowDeck() {
        
        loadingIndicatorView.stopAnimating()
        ShowControlBar()
        self.card.transform = CGAffineTransform.init(translationX: 0, y: 300)
        self.cardOverlay.alpha = 1
        self.cardOverlay.backgroundColor = UIColor(named: "deepBlue")
        self.cardOverlay.isHidden = false
        self.cardSecond.transform = CGAffineTransform.init(translationX: 0, y: 340)
        self.cardThird.transform = CGAffineTransform.init(translationX: 0, y: 380)
        card.isHidden = false;
        cardSecond.isHidden = false;
        cardThird.isHidden = false;
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.card.transform = CGAffineTransform.identity
            self.cardOverlay.alpha = 0
            self.cardOverlay.backgroundColor = UIColor(named: "blueGreyToo")
            self.cardSecond.transform = CGAffineTransform.identity
            self.cardThird.transform = CGAffineTransform.identity
        })
    }
    
    //MARK: - API
    
    func getSuggestedWords() {
        Api.Word.getSuggestedWords(onSuccess: { suggestedWords in
            self.cardDeckData = suggestedWords
            self.isCardFirst = true
            self.CheckDeckLength()
            self.ShowDeck()
        }, onError: {})
    }
}

//
//  GameLobbyViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/29.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class GameLobbyViewController: UIViewController {
    
    //Haptics
    let impact = UIImpactFeedbackGenerator()
    let notificationTap = UINotificationFeedbackGenerator()
    let selectionTap = UISelectionFeedbackGenerator()
    
    //Shared
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    var gameAction = "new"
    
    //Players
    @IBOutlet var playerCountLabel: UILabel!
    @IBOutlet var friendsJoinLabel: UILabel!

    //Pass Phrase
    @IBOutlet var passPhraseCollectionView: UICollectionView!
    @IBOutlet var passPhraseOptionsCollectionView: UICollectionView!
    var passPhraseItems : Array<String> = []
    var passPhraseOptions : Array<String> = passPhrase.shuffled()
    @IBOutlet var passPhraseLimitLabel: UILabel!
    @IBOutlet var setPhraseButton: DesignableButton!
    @IBOutlet var passPhraseArea: DesignableView!
    
    //Loading Indicators
    @IBOutlet weak var creatingGameLoading: NVActivityIndicatorView!
    @IBOutlet var creatingGameLoadingView: UIView!
    @IBOutlet var creatingGameOverlayLabel: UILabel!
    @IBOutlet var creatingGameOverlayError: UIImageView!
    @IBOutlet var startGameLoading: NVActivityIndicatorView!
    
    //Warning
    @IBOutlet var onePlayerWarningView: UIView!
    @IBOutlet var onePlayerStartGameButton: DesignableButton!
    @IBOutlet var onePlayerWaitFriendsButton: DesignableButton!
    
    //Start Game
    @IBOutlet var startGameButton: DesignableButton!
    @IBOutlet var startGameInfoView: UIView!
    @IBOutlet weak var passPhraseLabel: UILabel!
    @IBOutlet weak var playersTableView: UITableView!
    var players : Array<Player> = []
    
    //Categories
    @IBOutlet var categoryOverlay: UIView!
    @IBOutlet var categoriesStackView: UIStackView!
    @IBOutlet var catagoryLabel: UILabel!
    @IBOutlet var catagoryIcon: UIImageView!
    @IBOutlet var randomCheck: UIImageView!
    @IBOutlet var randomIcon: UIImageView!
    @IBOutlet var joyIcon: UIImageView!
    @IBOutlet var joyCheck: UIImageView!
    @IBOutlet var angerIcon: UIImageView!
    @IBOutlet var angerCheck: UIImageView!
    @IBOutlet var fearIcon: UIImageView!
    @IBOutlet var fearCheck: UIImageView!
    @IBOutlet var sadnessIcon: UIImageView!
    @IBOutlet var sadnessCheck: UIImageView!
    @IBOutlet var changeCatagoryButton: UIButton!
    @IBOutlet var catagoryView: DesignableView!
    @IBOutlet var setCatagoryButton: DesignableButton!
    
    //Colour
    var accentColour = "Purple-Accent"
    var backgroundColour = "Purple-Background"
    
    //Models
    let currentGame = Game(passPhrase: "", catagory: "Joy", currentRound: 0, currentRoundCatagory: "", id: Api.User.currentUserId)
    
    //Globals
    private var addedMeAsPlayer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set theme
        setTheme()
        
        //Add Collection View
        passPhraseCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        passPhraseOptionsCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        
        if gameAction != "new" {
            subTitleLabel.text = "Join someone elses game"
            TitleLabel.text = "Enter Pass Phrase"
            setPhraseButton.setTitle("Join Game", for: .normal)
        }
    }
    
    func setTheme() {
        view.tintColor = UIColor.init(named: accentColour)
        view.backgroundColor = UIColor.init(named: backgroundColour)
        startGameButton.backgroundColor = UIColor.init(named: self.accentColour)
        setCatagoryButton.backgroundColor = UIColor.init(named: self.accentColour)
        catagoryView.borderColor = UIColor.init(named: self.accentColour)
    }
    
    // MARK: - Back/Cancel
    
    @IBAction func onBackPressed(_ sender: Any) {
        selectionTap.selectionChanged()
        self.dismiss(animated: true)
        removeListners()
        deleteGame()
        if gameAction != "new" {
            removePlayer(gameID: currentGame.id)
        }
    }

    // MARK: - Pass Phrase
    
    //Pass Phrase Animation
    func shakeLimitLabel() {
        playSound(soundName: soundError)
        notificationTap.notificationOccurred(.error)
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
            playSound(soundName: soundButtonSelect)
            impact.impactOccurred()
            if gameAction == "new" {
                currentGame.passPhrase = mergePassPhrase()
                createGame()
            } else {
                listenForGame()
            }
        } else {
            shakeLimitLabel()
        }
    }
    
    func mergePassPhrase() -> String {
        var sentenceString = ""
        for word in passPhraseItems {
            sentenceString = "\(sentenceString) \(word)"
        }
        return sentenceString
    }
    // MARK: - Game Setup
    
    func initGameInfo() {
        catagoryLabel.text = self.currentGame.catagory
        catagoryIcon.image = UIImage.init(named: self.currentGame.catagory)
        passPhraseLabel.text = mergePassPhrase()
        if gameAction != "new" {
            startGameButton.backgroundColor = .clear
            startGameButton.setTitle("Waiting to Start", for: .normal)
            startGameButton.setTitleColor(UIColor.init(named: accentColour), for: .normal)
            startGameButton.isUserInteractionEnabled = false
            changeCatagoryButton.isHidden = true
            catagoryView.borderColor = UIColor.init(named: "Card-Neutral")
        }
    }
    
    // MARK: - Category Selection
    
    @IBAction func onChngeCategoryTapped(_ sender: Any) {
        showCategoryOverlay()
    }
    
    func showCategoryOverlay() {
        playSound(soundName: soundMenuSelect)
        self.view.addSubview(categoryOverlay)
        categoryOverlay.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.categoryOverlay.tintColor = UIColor.init(named: self.accentColour)
        self.categoryOverlay.alpha = 0
        self.categoryOverlay.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        self.categoriesStackView.transform = .init(scaleX: 1, y: 0)
        selectionTap.selectionChanged()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectionTap.selectionChanged()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.categoryOverlay.transform = .identity
                self.categoriesStackView.transform = .identity
                self.categoryOverlay.alpha = 1
            })
        }
    }
    
    @IBAction func selectCatagoryTapped(_ sender: UIButton) {
        playSound(soundName: soundItemSelect)
        selectionTap.selectionChanged()
        randomIcon.tintColor = UIColor.init(named: "Text-Primary")
        randomCheck.isHidden = true
        joyIcon.tintColor = UIColor.init(named: "Text-Primary")
        joyCheck.isHidden = true
        angerIcon.tintColor = UIColor.init(named: "Text-Primary")
        angerCheck.isHidden = true
        fearIcon.tintColor = UIColor.init(named: "Text-Primary")
        fearCheck.isHidden = true
        sadnessIcon.tintColor = UIColor.init(named: "Text-Primary")
        sadnessCheck.isHidden = true
        
        switch sender.tag {
        case 0:
            randomIcon.tintColor = view.tintColor
            randomCheck.isHidden = false
            self.currentGame.catagory = "Random"
            break
        case 1:
            joyIcon.tintColor = view.tintColor
            joyCheck.isHidden = false
            self.currentGame.catagory = "Joy"
            break
        case 2:
            angerIcon.tintColor = view.tintColor
            angerCheck.isHidden = false
            self.currentGame.catagory = "Anger"
            break
        case 3:
            fearIcon.tintColor = view.tintColor
            fearCheck.isHidden = false
            self.currentGame.catagory = "Fear"
            break
        case 4:
            sadnessIcon.tintColor = view.tintColor
            sadnessCheck.isHidden = false
            self.currentGame.catagory = "Sadness"
            break
        default:
            break
        }
    }
    
    @IBAction func onSetcatagoryTapped(_ sender: Any) {
        playSound(soundName: soundButtonSelect)
        hideCategoryOverlay()
        catagoryLabel.text = self.currentGame.catagory
        catagoryIcon.image = UIImage.init(named: self.currentGame.catagory)
        
        let documentData = [
            GAME_CATAGORY: self.currentGame.catagory
            ] as [String : Any]
        Api.Game.setGame(documentData: documentData, onSuccess: {
        }, onError: {error in
            print(error)
        })
    }
    
    func hideCategoryOverlay() {
        selectionTap.selectionChanged()
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.categoryOverlay.transform = CGAffineTransform.init(scaleX: 1, y: 0.8)
            self.categoryOverlay.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.categoryOverlay.transform = .identity
            self.categoriesStackView.transform = .identity
            self.categoryOverlay.alpha = 1
            self.categoryOverlay.removeFromSuperview()
        }
    }
    
    @IBAction func onCloseCatagoryOverlayTapped(_ sender: Any) {
        hideCategoryOverlay()
    }
    
    // MARK: - Start Game
    
    @IBAction func onStartGameTapped(_ sender: Any) {
        playSound(soundName: soundButtonSelect)
        if players.count < 2 {
            showOnePlayerWarning()
        } else {
            startGame()
        }
    }
    
    func startGame() {
        selectionTap.selectionChanged()
        startGameButton.setTitle("", for: .normal)
        startGameButton.isUserInteractionEnabled = false
        startGameLoading.startAnimating()
        let documentData = [
            GAME_CURRENT_ROUND: 1
            ] as [String : Any]
        Api.Game.setGame(documentData: documentData, onSuccess: {
            //startGameButton.setTitle("Error Starting Game", for: .normal)
            self.startGameLoading.stopAnimating()
            self.beginCountdown()
        }, onError: {error in
            print(error)
            self.startGameButton.setTitle("Error Starting Game", for: .normal)
            self.startGameButton.isUserInteractionEnabled = true
            self.startGameLoading.stopAnimating()
        })
    }
    
    func beginCountdown() {
        playSound(soundName: soundGameStartCountdown)
        selectionTap.selectionChanged()
        self.startGameButton.setTitle("Starting in 3", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            playSound(soundName: soundGameStartCountdown)
            self.startGameButton.setTitle("Starting in 2", for: .normal)
            self.selectionTap.selectionChanged()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            playSound(soundName: soundGameStartCountdown)
            self.startGameButton.setTitle("Starting in 1", for: .normal)
            self.selectionTap.selectionChanged()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            playSound(soundName: soundGameStartCountdown)
            self.performSegue(withIdentifier: "startGameSegue", sender: nil)
            self.notificationTap.notificationOccurred(.success)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        removeListners()
        if segue.identifier == "startGameSegue" {
            if let PlaySceneViewController = segue.destination as? PlaySceneViewController {
                PlaySceneViewController.currentRound = 1
                PlaySceneViewController.catagory = currentGame.catagory
                PlaySceneViewController.gameID = currentGame.id
                PlaySceneViewController.gameAction = gameAction
                PlaySceneViewController.passedPassPhrase = mergePassPhrase()
                PlaySceneViewController.accentColour = accentColour
                PlaySceneViewController.backgroundColour = backgroundColour
            }
        }
    }
    
    // MARK: - One Player Warning
    
    func showOnePlayerWarning() {
        self.view.addSubview(onePlayerWarningView)
        onePlayerWarningView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.onePlayerWarningView.tintColor = UIColor.init(named: self.accentColour)
        self.onePlayerStartGameButton.backgroundColor = UIColor.init(named: self.accentColour)
        self.onePlayerWaitFriendsButton.setTitleColor(UIColor.init(named: self.accentColour), for: .normal)
        self.onePlayerWarningView.alpha = 0
        self.onePlayerWarningView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        selectionTap.selectionChanged()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectionTap.selectionChanged()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.onePlayerWarningView.transform = .identity
                self.onePlayerWarningView.alpha = 1
            })
        }
    }
    
    func hideOnePlayerWarning() {
        selectionTap.selectionChanged()
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.onePlayerWarningView.transform = CGAffineTransform.init(scaleX: 1, y: 0.8)
            self.onePlayerWarningView.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.onePlayerWarningView.transform = .identity
            self.onePlayerWarningView.alpha = 1
            self.onePlayerWarningView.removeFromSuperview()
        }
    }
    
    @IBAction func onCloseOnePlayerWarningTapped(_ sender: Any) {
        playSound(soundName: soundButtonSelect)
        hideOnePlayerWarning()
    }
    
    @IBAction func onOnePlayerWarningStartGameTapped(_ sender: Any) {
        playSound(soundName: soundButtonSelect)
        hideOnePlayerWarning()
        startGame()
    }
    
    // MARK: - Animations
    
    func animateToStartGame() {
        selectionTap.selectionChanged()
        self.startGameInfoView.transform = .init(translationX: 0, y: 100)
        self.startGameInfoView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
             self.passPhraseOptionsCollectionView.transform = .init(translationX: 0, y: -100)
             self.passPhraseArea.transform = .init(translationX: 0, y: -100)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setPhraseButton.isHidden = true
            self.startGameButton.isHidden = false
            self.startGameInfoView.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
             self.passPhraseOptionsCollectionView.alpha = 0
             self.passPhraseArea.alpha = 0
             if self.gameAction == "new" {
                self.subTitleLabel.text = "My Game"
             } else {
                self.subTitleLabel.text = "Joined Game"
             }
             self.TitleLabel.text = "Pass Phrase"
             self.startGameInfoView.alpha = 1
            })
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.startGameInfoView.transform = .identity
            })
        }
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.selectionTap.selectionChanged()
             self.passPhraseOptionsCollectionView.isHidden = true
             self.passPhraseArea.isHidden = true
         }
    }
    
    // MARK: - Loading
    
    //Loading View
    func showLoadingOverlay() {
        self.view.addSubview(creatingGameLoadingView)
        creatingGameLoadingView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.creatingGameLoadingView.tintColor = UIColor.init(named: self.accentColour)
        self.creatingGameLoadingView.alpha = 0
        self.creatingGameOverlayError.isHidden = true
        self.creatingGameOverlayLabel.text = "Creating Game"
        self.creatingGameLoadingView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        creatingGameLoading.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.creatingGameLoadingView.transform = .identity
                self.creatingGameLoadingView.alpha = 1
            })
        }
    }
    
    func hideLoadingOverlay() {
        creatingGameLoading.stopAnimating()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.creatingGameLoadingView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
            self.creatingGameLoadingView.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.creatingGameLoadingView.transform = .identity
            self.creatingGameLoadingView.removeFromSuperview()
        }
    }
    // MARK: - API
    
    // Game
    func setGameDocument() -> [String : Any] {
        let documentData = [
            GAME_CREATION_DATE: FieldValue.serverTimestamp(),
            GAME_PASS_PHRASE: currentGame.passPhrase,
            GAME_CATAGORY: currentGame.catagory,
            GAME_CURRENT_ROUND: currentGame.currentRound,
            GAME_CURRENT_ROUND_CATAGORY: currentGame.currentRoundCatagory
            ] as [String : Any]
        return documentData
    }
    
    func createGame() {
        showLoadingOverlay()
        
        Api.Game.createGame(passPhrase: currentGame.passPhrase, documentData: setGameDocument(), onSuccess: {
            self.initGameInfo()
            self.addMeAsPlayer(gameID: Api.User.currentUserId)
        }, onError: {error in print(error)
            self.hideLoadingOverlay()
        })
    }
    
    func deleteGame() {
        Api.Game.deleteGame(onSuccess: {}, onError: {error in print(error)})
    }
    
    func listenForGame() {
        showLoadingOverlay()
        creatingGameOverlayLabel.text = "Joining Game"
        Api.Game.getGame(passPhrase: mergePassPhrase(), onSuccess: { (data) in
            self.hideLoadingOverlay()
            self.currentGame.passPhrase = data.passPhrase
            self.currentGame.catagory = data.catagory
            self.currentGame.currentRound = data.currentRound
            self.currentGame.currentRoundCatagory = data.currentRoundCatagory
            self.currentGame.id = data.id
            self.initGameInfo()
            if !self.addedMeAsPlayer {
                self.addMeAsPlayer(gameID: self.currentGame.id)
            }
            if self.currentGame.currentRound == 1 {
                self.beginCountdown()
            }
        }, onNotFound: {
            self.creatingGameLoading.stopAnimating()
            self.creatingGameOverlayLabel.text = "Game Not Found"
            self.creatingGameOverlayError.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.hideLoadingOverlay()
            }
        }, onError: {
//            self.dismiss(animated: true)
//            self.removeListners()
        })
    }
    
    // Player
    func addMeAsPlayer(gameID: String) {
        let documentData = [
            PLAYER_NAME: UserDefaults.standard.string(forKey: AVATAR_NAME)!,
            PLAYER_AVATAR: UserDefaults.standard.string(forKey: CURRENT_AVATAR_INDEX)!,
            PLAYER_SCORE: 0,
            ] as [String : Any]
        
        Api.Game.addPlayer(documentData: documentData, gameID: gameID, onSuccess: {
            self.addedMeAsPlayer = true
            self.hideLoadingOverlay()
            self.animateToStartGame()
            self.listenForPlayers(gameID: gameID)
        }, onError: {error in print(error)})
    }
    
    func listenForPlayers(gameID: String) {
        Api.Game.getPlayers(gameID: gameID, onSuccess: { (data) in
            self.players = []
            self.players = data
            if self.players.count < 1 {
                self.dismiss(animated: true)
                self.removeListners()
                return
            }
            if self.players.count > 1 {
                self.playerCountLabel.text = "\(self.players.count) Players"
                self.friendsJoinLabel.isHidden = true
            } else {
                self.playerCountLabel.text = "1 Player"
                self.friendsJoinLabel.isHidden = false
            }
            self.selectionTap.selectionChanged()
            self.playersTableView.reloadData()
        }, onGameEnded: {
            self.dismiss(animated: true)
        })
    }
    
    func removePlayer(gameID: String) {
        Api.Game.removePlayerFromGame(gameID: gameID, onSuccess: {})
    }
    
    //Observalbles
    func removeListners() {
        Api.Game.removeGetPlayersObservers()
        Api.Game.removeGetGameObservers()
    }
}

// MARK: - Collection View Delegates

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
                cell.pillBackground.backgroundColor = UIColor.init(named: "Card-Neutral")
                cell.pillWord.text = passPhraseOptions[indexPath.item]
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPillCollectionViewCell", for: indexPath) as! WordPillCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        selectionTap.selectionChanged()
        playSound(soundName: soundItemSelect)
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

// MARK: - Table View Delegates

extension GameLobbyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayersTableViewCell", for: indexPath) as! PlayersTableViewCell
        
        if players[indexPath.row].id == Api.User.currentUserId {
            cell.playerNameLabel.text = "Me"
        } else {
            cell.playerNameLabel.text = players[indexPath.row].name
        }

        let currentAvatar = avatars[Int(players[indexPath.row].avatar) ?? 0]
        cell.playerAvatarImage.image = UIImage.init(named: currentAvatar.icon)
        cell.avatarPlanetImage.image = UIImage.init(named: currentAvatar.background)
        cell.avatarPlanetImage.tintColor = UIColor.init(named: currentAvatar.colour + "-Background")

        return cell
    }
    
}

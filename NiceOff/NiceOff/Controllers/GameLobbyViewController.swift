//
//  GameLobbyViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/29.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class GameLobbyViewController: UIViewController {
    
    //Shared
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    var gameAction = "new"
    
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
    
    //Start Game
    @IBOutlet var startGameButton: DesignableButton!
    @IBOutlet var startGameInfoView: UIView!
    @IBOutlet weak var passPhraseLabel: UILabel!
    @IBOutlet weak var playersTableView: UITableView!
    var players : Array<Player> = []
    
    //Colour
    var accentColour = "Purple-Accent"
    var backgroundColour = "Purple-Background"
    
    //Models
    let currentGame = Game(passPhrase: "", catagory: "joy", currentRound: 0, currentRoundCatagory: "", id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Collection View
        passPhraseCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        passPhraseOptionsCollectionView.register(UINib(nibName: "WordPillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordPillCollectionViewCell")
        
        if gameAction != "new" {
            subTitleLabel.text = "Join someone elses game"
            TitleLabel.text = "Enter Pass Phrase"
            setPhraseButton.setTitle("Join Game", for: .normal)
        }
    }
    
    // MARK: - Back/Cancel
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool){
        removeListners()
        deleteGame()
    }
    
    // MARK: - Pass Phrase
    
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
        passPhraseLabel.text = mergePassPhrase()
    }
    
    // MARK: - Start Game
    
    @IBAction func onStartGameTapped(_ sender: Any) {
        performSegue(withIdentifier: "startGameSegue", sender: nil)
    }
    
    // MARK: - Animations
    
    func animateToStartGame() {
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
            GAME_PASS_PHRASE: currentGame.passPhrase,
            GAME_CATAGORY: currentGame.catagory,
            GAME_CURRENT_ROUND: currentGame.currentRound,
            GAME_CURRENT_ROUND_CATAGORY: currentGame.currentRoundCatagory
            ] as [String : Any]
        return documentData
    }
    
    func createGame() {
        showLoadingOverlay()
        
        Api.Game.setGame(documentData: setGameDocument(), onSuccess: {
            self.initGameInfo()
            self.addMeAsPlayer(gameID: Api.User.currentUserId)
        }, onError: {error in print(error)})
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
            self.initGameInfo()
            self.addMeAsPlayer(gameID: data.id)
        }, onNotFound: {
            self.creatingGameLoading.stopAnimating()
            self.creatingGameOverlayLabel.text = "Game Not Found"
            self.creatingGameOverlayError.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.hideLoadingOverlay()
            }
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
            self.hideLoadingOverlay()
            self.animateToStartGame()
            self.listenForPlayers(gameID: gameID)
        }, onError: {error in print(error)})
    }
    
    func listenForPlayers(gameID: String) {
        Api.Game.getPlayers(gameID: gameID, onSuccess: { (data) in
            self.players = []
            self.players = data
            self.playersTableView.reloadData()
        }, onGameEnded: {
            self.dismiss(animated: true)
        })
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

//
//  ViewController.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/28.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    //Haptics
    let impact = UIImpactFeedbackGenerator()
    let notificationTap = UINotificationFeedbackGenerator()
    let selectionTap = UISelectionFeedbackGenerator()
    
    //Avatar
    @IBOutlet var avatarNameButton: UIButton!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var avatarBackgroundImage: UIImageView!
    @IBOutlet var swipeLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    
    //Loading View
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    
    //Actions
    @IBOutlet var startButtonBackground: DesignableView!
    @IBOutlet var joinButtonBackground: DesignableView!
    
    //Onboarding
    @IBOutlet var onboardingScrollView: UIScrollView!
    @IBOutlet var onboardingViewContainer: UIView!
    
    var gameAction = "new"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            showLoadingOverlay()
            //Onboarding
            onboardingScrollView.delegate = self
            let slides:[OnboardingFrameUIView] = CreateSlides()
            SetupSlideScrollView(slides: slides)
            Api.User.signInAnonymously(onSuccess: {self.loginSuccess()}, onError: {error in self.loginError(error: error)})
        } else {
            Api.Game.deleteGame(onSuccess: {print("Game Deleted")}, onError: {error in print(error)})
            setInitialAvatar()
        }
        //Api.User.logOut()
    }
    
    // MARK: - Login Functions
    
    func loginSuccess() {
        hideLoadingOverlay()
        setInitialAvatar()
    }
    
    func loginError(error: String) {
        print(error)
    }
    
    //Loading View
    func showLoadingOverlay() {
        self.view.addSubview(loadingView)
        loadingView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingOverlay() {
        loadingIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.loadingView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.loadingView.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loadingView.removeFromSuperview()
        }
    }
    
    // MARK: - Avatar Functions

    //Change Avatar Name
    @IBAction func onAvatarNameTapped(_ sender: UIButton) {
        playSound(soundName: soundItemSelect)
        selectionTap.selectionChanged()
        
        let firsName = avatarNameFirst.randomElement() ?? "Happy"
        let lastName = avatarNameLast.randomElement() ?? "Dwarf"
        let fullName = firsName + " " + lastName
        
        UserDefaults.standard.set(fullName, forKey: AVATAR_NAME)
        self.avatarNameButton.setTitle(fullName, for: .normal)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.avatarNameButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            self.avatarNameButton.alpha = 0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            playSound(soundName: soundMenuSelect)
            self.impact.impactOccurred()
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.avatarNameButton.transform = CGAffineTransform.identity
                self.avatarNameButton.alpha = 1
            })
        }
    }
    
    @IBAction func onNewGameDown(_ sender: Any) {
        playSound(soundName: soundButtonPress)
        selectionTap.selectionChanged()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.startButtonBackground.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            self.startButtonBackground.shadowRadius = 0
            self.startButtonBackground.shadowOpacity = 0
        })
    }
    
    @IBAction func onNewGameUp(_ sender: Any) {
        selectionTap.selectionChanged()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.startButtonBackground.transform = CGAffineTransform.identity
            self.startButtonBackground.shadowRadius = 10
            self.startButtonBackground.shadowOpacity = 1
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.gameAction = "new"
            self.performSegue(withIdentifier: "showLobby", sender: nil)
        }
    }
    
    @IBAction func joinNewGameDown(_ sender: Any) {
        playSound(soundName: soundButtonPress)
        selectionTap.selectionChanged()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.joinButtonBackground.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            self.joinButtonBackground.shadowRadius = 0
            self.joinButtonBackground.shadowOpacity = 0
        })
    }
    
    @IBAction func joinNewGameUp(_ sender: Any) {
        selectionTap.selectionChanged()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.joinButtonBackground.transform = CGAffineTransform.identity
            self.joinButtonBackground.shadowRadius = 10
            self.joinButtonBackground.shadowOpacity = 1
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.gameAction = "join"
            self.performSegue(withIdentifier: "showLobby", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var currentAvatarIndex = 0
        if let index = UserDefaults.standard.string(forKey: CURRENT_AVATAR_INDEX){
            currentAvatarIndex = Int(index) ?? 0
        }

        if segue.identifier == "showLobby" {
            if let GameLobbyViewController = segue.destination as? GameLobbyViewController {
                GameLobbyViewController.gameAction = gameAction
                GameLobbyViewController.accentColour = "\(avatars[currentAvatarIndex].colour)-Accent"
                GameLobbyViewController.backgroundColour = "\(avatars[currentAvatarIndex].colour)-Background"
            }
        }
        if segue.identifier == "toAddWordsSegue" {
            if let AddWordsViewController = segue.destination as? AddWordsViewController {
                AddWordsViewController.accentColour = "\(avatars[currentAvatarIndex].colour)-Accent"
                AddWordsViewController.backgroundColour = "\(avatars[currentAvatarIndex].colour)-Background"
            }
        }
    }
    
    //Change Avatar Image to Before
    @IBAction func onAvatarSwipeRight(_ sender: UISwipeGestureRecognizer) {
        changeAvatar(isLeft: false)
    }
    
    //Change Avatar Image to Next
    @IBAction func onAvatarSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        changeAvatar(isLeft: true)
    }
    
    func changeAvatar(isLeft: Bool) {
        playSound(soundName: soundItemSelect)
        var currentAvatarIndex = "0"
        
        if let index = UserDefaults.standard.string(forKey: CURRENT_AVATAR_INDEX){
            currentAvatarIndex = index
        } else {
            UserDefaults.standard.set("0", forKey: CURRENT_AVATAR_INDEX)
        }
        
        var newAvatarIndex = 0
        if isLeft {
            if Int(currentAvatarIndex) ?? 0 == 0 {
                newAvatarIndex = avatars.count - 1
            } else {
                newAvatarIndex = (Int(currentAvatarIndex) ?? 0) - 1
            }
        } else {
            if Int(currentAvatarIndex) ?? 0 == avatars.count - 1 {
                newAvatarIndex = 0
            } else {
                newAvatarIndex = (Int(currentAvatarIndex) ?? 0) + 1
            }
        }
        UserDefaults.standard.set(String(newAvatarIndex), forKey: CURRENT_AVATAR_INDEX)
        let newAvatar = avatars[newAvatarIndex]
        
        selectionTap.selectionChanged()
        
        //Animate Out
        if isLeft {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.avatarBackgroundImage.transform = CGAffineTransform.init(translationX: -self.view.frame.width - 100, y: 0)
            })
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.avatarImage.transform = CGAffineTransform.init(translationX: -self.view.frame.width, y: 0)
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.avatarBackgroundImage.transform = CGAffineTransform.init(translationX: self.view.frame.width + 100, y: 0)
            })
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.avatarImage.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            playSound(soundName: soundMenuSelect)
            self.selectionTap.selectionChanged()
            if isLeft {
                self.avatarBackgroundImage.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
                self.avatarImage.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
            } else {
                self.avatarBackgroundImage.transform = CGAffineTransform.init(translationX: -self.view.frame.width, y: 0)
                self.avatarImage.transform = CGAffineTransform.init(translationX: -self.view.frame.width, y: 0)
            }
            
            //Images
            self.avatarImage.image = UIImage.init(named: newAvatar.icon)
            self.avatarBackgroundImage.image = UIImage.init(named: newAvatar.background)
            
            //Colours
            let accentColour = UIColor.init(named: newAvatar.colour + "-Accent")
            
            self.view.tintColor = accentColour
            self.startButtonBackground.backgroundColor = accentColour
            self.swipeLabel.textColor = accentColour
            self.tapLabel.textColor = accentColour
            self.view.backgroundColor = UIColor.init(named: newAvatar.colour + "-Background")
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.avatarBackgroundImage.transform = CGAffineTransform.identity
            })
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.avatarImage.transform = CGAffineTransform.identity
            })
        }

    }
    
    func setInitialAvatar() {
        
        getWordData()
        var avatarIndex = "0"
        
        if let index = UserDefaults.standard.string(forKey: CURRENT_AVATAR_INDEX){
            avatarIndex = index
        } else {
            UserDefaults.standard.set("0", forKey: CURRENT_AVATAR_INDEX)
        }
        let currentAvatar = avatars[Int(avatarIndex) ?? 0]
        
        //Images
        avatarImage.image = UIImage.init(named: currentAvatar.icon)
        avatarBackgroundImage.image = UIImage.init(named: currentAvatar.background)
        
        //Colours
        let accentColour = UIColor.init(named: currentAvatar.colour + "-Accent")
        
        self.view.tintColor = accentColour
        startButtonBackground.backgroundColor = accentColour
        swipeLabel.textColor = accentColour
        self.tapLabel.textColor = accentColour
        self.view.backgroundColor = UIColor.init(named: currentAvatar.colour + "-Background")

        //Text
        var avatarName = ""
        
        if let name = UserDefaults.standard.string(forKey: AVATAR_NAME){
            avatarName = name
        } else {
            let firsName = avatarNameFirst.randomElement() ?? "Happy"
            let lastName = avatarNameLast.randomElement() ?? "Dwarf"
            let fullName = firsName + " " + lastName
            avatarName = fullName
            UserDefaults.standard.set(fullName, forKey: AVATAR_NAME)
        }
        
        self.avatarNameButton.setTitle(avatarName, for: .normal)
    }
    
    // MARK: - Login Functions
    func CreateSlides() -> [OnboardingFrameUIView] {
        let slide1:OnboardingFrameUIView = Bundle.main.loadNibNamed("OnboardingFrameUIView", owner: self, options: nil)?.first as! OnboardingFrameUIView
        slide1.onboardingImage.image = UIImage(named:"onboarding1")
        slide1.Onboarding1Title.isHidden = false
        slide1.onboardingBody.isHidden = true
        slide1.onboardingSwipeText.text = "swipe to discover word space"
        
        let slide2:OnboardingFrameUIView = Bundle.main.loadNibNamed("OnboardingFrameUIView", owner: self, options: nil)?.first as! OnboardingFrameUIView
        slide2.onboardingImage.image = UIImage(named:"onboarding2")
        slide2.Onboarding1Title.isHidden = true
        slide2.onboardingBody.isHidden = false
        slide2.onboardingBody.text = "You are almost ready to join humans on earth! The only thing left to do is learn one of their languages."
        slide2.onboardingSwipeText.text = "word space is here to help!"
        
        let slide3:OnboardingFrameUIView = Bundle.main.loadNibNamed("OnboardingFrameUIView", owner: self, options: nil)?.first as! OnboardingFrameUIView
        slide3.onboardingImage.image = UIImage(named:"onboarding3")
        slide3.Onboarding1Title.isHidden = true
        slide3.onboardingBody.isHidden = false
        slide3.onboardingBody.text = "Build sentences according to a specific emotion and see your sentence score."
        slide3.onboardingSwipeText.text = "what about my friends?"
        
        let slide4:OnboardingFrameUIView = Bundle.main.loadNibNamed("OnboardingFrameUIView", owner: self, options: nil)?.first as! OnboardingFrameUIView
        slide4.onboardingImage.image = UIImage(named:"onboarding4")
        slide4.Onboarding1Title.isHidden = true
        slide4.onboardingBody.isHidden = false
        slide4.onboardingBody.text = "Play with all your friends!"
        slide4.onboardingSwipeText.isHidden = true
        slide4.onboardingDoneButton.isHidden = false
        slide4.onboardingDoneButton.tag = 0
        slide4.onboardingDoneButton.addTarget(self,  action: #selector(dismissOnboarding), for: .touchUpInside)
        
        return [slide1, slide2, slide3, slide4]
    }
    
    @objc func dismissOnboarding(_ sender: UIButton) {
        playSound(soundName: soundButtonSelect)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.onboardingViewContainer.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.onboardingViewContainer.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.onboardingViewContainer.removeFromSuperview()
        }
    }
    
    func SetupSlideScrollView(slides:[OnboardingFrameUIView]) {
        self.view.addSubview(onboardingViewContainer)
        onboardingViewContainer.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)
        onboardingScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: onboardingScrollView.frame.height)
        onboardingScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: onboardingScrollView.frame.height)

        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: onboardingScrollView.frame.height)
            onboardingScrollView.addSubview(slides[i])
        }
        
    }
    //MARK: - Api
    
    func getWordData() {
        Api.Word.getGameWords(onSuccess: {}, onError: {})
    }
}


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

class HomeViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            showLoadingOverlay()
            Api.User.signInAnonymously(onSuccess: {self.loginSuccess()}, onError: {error in self.loginError(error: error)})
        } else {
            setInitialAvatar()
        }
        //Api.User.logOut()
    }
    
    // MARK: Login Functions
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

    //Change Avatar Name
    @IBAction func onAvatarNameTapped(_ sender: UIButton) {
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
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.avatarNameButton.transform = CGAffineTransform.identity
                self.avatarNameButton.alpha = 1
            })
        }
    }
    
    @IBAction func onNewGameDown(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.startButtonBackground.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            self.startButtonBackground.shadowRadius = 0
            self.startButtonBackground.shadowOpacity = 0
        })
    }
    
    @IBAction func onNewGameUp(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.startButtonBackground.transform = CGAffineTransform.identity
            self.startButtonBackground.shadowRadius = 10
            self.startButtonBackground.shadowOpacity = 1
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performSegue(withIdentifier: "showLobby", sender: nil)
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
}


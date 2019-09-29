//
//  UIButton+Designable.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/28.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var rounded: Bool = false {
        didSet {
            if rounded {
                layer.cornerRadius = layer.bounds.height / 2
            } else {
                layer.cornerRadius = 0
            }
        }
    }
    
    @IBInspectable
    var lightBackground: Bool = false {
        didSet {
            if lightBackground {
                let color = self.titleLabel?.textColor.cgColor
                layer.backgroundColor = UIColor(cgColor: color!).withAlphaComponent(0.1).cgColor
            } else {
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    var image: UIImage? = nil {
        didSet {
            if let img = image {
                self.imageView?.contentMode = .scaleAspectFit
                self.setImage(img, for: .normal)
                
                if imageView != nil {
                    imageEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: (bounds.width - 45))
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageView?.frame.width)! * 2, bottom: 0, right: 0)
                }
                
            }
        }
    }
}

class ButtonWithImage: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 10), bottom: 5, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}


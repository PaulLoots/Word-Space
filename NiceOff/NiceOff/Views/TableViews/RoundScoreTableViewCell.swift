//
//  RoundScoreTableViewCell.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/19.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RoundScoreTableViewCell: UITableViewCell {

    @IBOutlet var sentenceScore: UILabel!
    @IBOutlet var sentenceLabel: UILabel!
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var playerName: UILabel!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var likeIcon: UIImageView!
    @IBOutlet var likeBackground: DesignableView!
    @IBOutlet var typingIndicator: NVActivityIndicatorView!
    @IBOutlet var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  PlayersTableViewCell.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/14.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit

class PlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var avatarPlanetImage: UIImageView!
    @IBOutlet weak var playerAvatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

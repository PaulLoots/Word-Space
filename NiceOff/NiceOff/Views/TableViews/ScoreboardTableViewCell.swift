//
//  ScoreboardTableViewCell.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/10/19.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import UIKit

class ScoreboardTableViewCell: UITableViewCell {

    @IBOutlet var planetImage: UIImageView!
    @IBOutlet var place: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var score: UILabel!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

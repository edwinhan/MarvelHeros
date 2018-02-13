//
//  MHHeroDetailItemTableViewCell.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHHeroDetailItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

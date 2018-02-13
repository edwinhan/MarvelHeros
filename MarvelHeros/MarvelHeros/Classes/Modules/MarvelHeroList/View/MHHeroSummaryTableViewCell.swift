//
//  MHHeroSummaryTableViewCell.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/12.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHHeroSummaryTableViewCell: UITableViewCell {

    var recordID:String = ""
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modifiedLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        if MHFavoriteCharacterWrapper.sharedInstance.checkIsFavoriteCharacter(characterId: self.recordID) {
            MHFavoriteCharacterWrapper.sharedInstance.removeFavoriteCharacter(characterId: self.recordID)
            
            self.favoriteButton.setImage(UIImage(named: "star-unfilled.png"), for: UIControlState.normal)
        } else {
            MHFavoriteCharacterWrapper.sharedInstance.addFavoriteCharacter(characterId: self.recordID)
            
            self.favoriteButton.setImage(UIImage(named: "star-filled.png"), for: UIControlState.normal)
        }
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

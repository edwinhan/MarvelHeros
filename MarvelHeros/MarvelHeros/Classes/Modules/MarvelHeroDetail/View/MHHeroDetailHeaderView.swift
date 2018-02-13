//
//  MHHeroDetailHeaderView.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHHeroDetailHeaderView: UIView {

    var characterModel:MHCharacterModel?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var descriptionValue: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    let originHeaderViewHeight:CGFloat = 260.0
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        if let characterId = self.characterModel?.id {
            if MHFavoriteCharacterWrapper.sharedInstance.checkIsFavoriteCharacter(characterId: characterId) {
                MHFavoriteCharacterWrapper.sharedInstance.removeFavoriteCharacter(characterId: characterId)
                
                self.favoriteButton.setImage(UIImage(named: "star-unfilled.png"), for: UIControlState.normal)
            } else {
                MHFavoriteCharacterWrapper.sharedInstance.addFavoriteCharacter(characterId: characterId)
                
                self.favoriteButton.setImage(UIImage(named: "star-filled.png"), for: UIControlState.normal)
            }
        } else {
            //TODO: show alert to let user know that no characterId here
        }
        
    }
    func configureHeaderViewWithCompletionHandler(character:MHCharacterModel, handler:@escaping ((CGFloat)->Void))->Void {
        
        self.characterModel = character
        
        //set image
        if self.characterModel?.id != nil && self.characterModel?.modifiedDate != nil && self.characterModel?.thumbnailPath != nil && self.characterModel?.thumbnailExtension != nil {
            MHImageDowloader.loadImage(imageName: "\(self.characterModel!.id!)_\(self.characterModel!.modifiedDate!.replacingOccurrences(of: ":", with: "")).\(self.characterModel!.thumbnailExtension!)", imageUrl: "\(self.characterModel!.thumbnailPath!).\(self.characterModel!.thumbnailExtension!)", completionHandler: { (image:UIImage?)->Void in
                
                self.detailImageView.image = image
                
            })
        } else {
            self.detailImageView.image = UIImage(named: "imageNotFound.jpg")
        }
        
        // set favorite button
        if let id = self.characterModel?.id {
            
            if MHFavoriteCharacterWrapper.sharedInstance.checkIsFavoriteCharacter(characterId: id) {
                
                self.favoriteButton.setImage(UIImage(named: "star-filled.png"), for: UIControlState.normal)
            } else {
                self.favoriteButton.setImage(UIImage(named: "star-unfilled.png"), for: UIControlState.normal)
            }
        }
        
        //set name label
        self.nameValueLabel.text = self.characterModel?.name
        
        self.descriptionValue.text = self.characterModel?.characterDescription ?? "NA"
        self.descriptionValue.sizeThatFits(CGSize(width: self.descriptionValue.frame.size.width, height: CGFloat(MAXFLOAT)))
        handler(originHeaderViewHeight + self.descriptionValue.contentSize.height)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  ProfileCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Konstantins Belcickis on 26/02/2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var postImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.postImageView = UIImageView.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.postImageView = UIImageView.init()
    }
    
}


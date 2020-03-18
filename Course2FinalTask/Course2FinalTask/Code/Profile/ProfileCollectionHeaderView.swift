//
//  ProfileCollectionHeaderView.swift
//  Course2FinalTask
//
//  Created by Konstantins Belcickis on 26/02/2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func watchSubscribers(subscribersType: SubscribersType)
}

enum SubscribersType {
    case followers
    case following
}

class ProfileCollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet  var userAvatarImageView: UIImageView!
    @IBOutlet  var userNameLabel: UILabel!
    @IBOutlet  var followersLabel: UILabel!
    @IBOutlet  var followingLabel: UILabel!
    
    var delegate: ProfileHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        userAvatarImageView = UIImageView.init()
        userNameLabel = UILabel.init()
        followersLabel = UILabel.init()
        followingLabel = UILabel.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        userAvatarImageView = UIImageView.init()
        userNameLabel = UILabel.init()
        followersLabel = UILabel.init()
        followingLabel = UILabel.init()
    }
    
    override func awakeFromNib() {
        addTapToWatchSubscribersGestureRecognizer(element: followersLabel)
        addTapToWatchSubscribersGestureRecognizer(element: followingLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.clipsToBounds = true
    }
    
    func addTapToWatchSubscribersGestureRecognizer(element: UILabel) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(watchSubscribersGestureRecognizerTapped(sender:)))
        gestureRecognizer.numberOfTapsRequired = 1
        
        element.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func watchSubscribersGestureRecognizerTapped(sender: UITapGestureRecognizer) {
        if let currentLabel = sender.view {
            if currentLabel.tag == 666 {
                delegate?.watchSubscribers(subscribersType: .followers)
            } else {
                delegate?.watchSubscribers(subscribersType: .following)
            }
        }
    }
    
}

//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Konstantins Belcickis on 26/02/2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likedByCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bigLikeImageView: UIImageView!
    
    weak var delegate: FeedTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerTapGestureRecognizers()
        
        addGestureRecognizers()
        bigLikeImageView.alpha = 0.0
    }
    
    @IBAction func likePostButtonPressed(_ sender: UIButton) {
        delegate?.likePost(cell: self, withAnimation: false)
    }
    
    @objc func tapToWatchProfileGestureRecognizerPressed() {
        delegate?.watchProfile(cell: self)
    }
    
    @objc func tapToWatchSubscribersGestureRecognizerPressed() {
        delegate?.watchSubsribers(cell: self)
    }
    
    @objc func showBigLikeAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
            self.bigLikeImageView.alpha = 1.0
        }, completion: {_ in
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
                self.bigLikeImageView.alpha = 0
            }, completion: nil)
        })
        
        if likeButton.tintColor == UIColor.lightGray {
            delegate?.likePost(cell: self, withAnimation: true)
        }
    }
    
    func registerTapGestureRecognizers() {
        
        let tapBigLike = UITapGestureRecognizer(target: self, action: #selector(showBigLikeAnimation))
        tapBigLike.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tapBigLike)
    }
    
    func addGestureRecognizers() {
        
        let tapToWatchSubscribersGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToWatchSubscribersGestureRecognizerPressed))
        tapToWatchSubscribersGestureRecognizer.numberOfTapsRequired = 1
        
        likedByCountLabel.addGestureRecognizer(tapToWatchSubscribersGestureRecognizer)
        addTapToWatchProfileGestureRecognizer(element: authorAvatarImageView)
        addTapToWatchProfileGestureRecognizer(element: authorUsernameLabel)
        addTapToWatchProfileGestureRecognizer(element: createdTimeLabel)
    }
    
    func addTapToWatchProfileGestureRecognizer(element: UIView) {
        let tapToWatchProfileGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToWatchProfileGestureRecognizerPressed))
        tapToWatchProfileGestureRecognizer.numberOfTapsRequired = 1
        
        element.addGestureRecognizer(tapToWatchProfileGestureRecognizer)
    }
    
}

//
//  FeedTableViewController.swift
//  Course2FinalTask
//
//  Created by Konstantins Belcickis on 26/02/2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedTableViewController: UITableViewController {
    
    private var usersLikedPost = [User]()
    public var post: [Post] = DataProviders.shared.postsDataProvider.feed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 551
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataProviders.shared.postsDataProvider.feed().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedTableViewCell
            else { return UITableViewCell() }
        
        let currentPost = DataProviders.shared.postsDataProvider.feed()[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true;
        
        let postDateAsString = dateFormatter.string(from: currentPost.createdTime)
        
        cell.authorAvatarImageView.image = currentPost.authorAvatar
        cell.authorUsernameLabel.text = currentPost.authorUsername
        cell.createdTimeLabel.text = postDateAsString
        cell.postImageView.image = currentPost.image
        cell.likedByCountLabel.text = "Likes: \(currentPost.likedByCount)"
        cell.descriptionLabel.text = currentPost.description
        
        if currentPost.currentUserLikesThisPost {
            cell.likeButton.tintColor = UIColor.blue
        } else {
            cell.likeButton.tintColor = UIColor.lightGray
        }
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - likePost
    
    func likePost(cell: FeedTableViewCell, withAnimation: Bool){
        if let indexPath = tableView.indexPath(for: cell) {
            
            if cell.likeButton.tintColor == UIColor.lightGray {
                
                if DataProviders.shared.postsDataProvider.likePost(with: post[indexPath.row].id) {
                    post[indexPath.row].currentUserLikesThisPost = true
                    post[indexPath.row].likedByCount += 1
                    cell.likeButton.tintColor = .blue
                }
                
            } else if cell.likeButton.tintColor == UIColor.blue   {
                if DataProviders.shared.postsDataProvider.unlikePost(with: post[indexPath.row].id) {
                    post[indexPath.row].currentUserLikesThisPost = false
                    post[indexPath.row].likedByCount -= 1
                    cell.likeButton.tintColor = .lightGray
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func watchSubsribers(cell: FeedTableViewCell) {
        if let post = findPostFromCell(cell: cell) {
            if let usersID = DataProviders.shared.postsDataProvider.usersLikedPost(with: post.id) {
                usersLikedPost = usersID.compactMap{ currentUserID in
                    DataProviders.shared.usersDataProvider.user(with: currentUserID)
                }
                if usersLikedPost.count > 0 {
                    self.performSegue(withIdentifier: "ShowUsersFromFeed", sender: nil)
                }
            }
        }
    }
    
    func watchProfile(cell: FeedTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let currentPost = DataProviders.shared.postsDataProvider.feed()[indexPath.row]
            if let author = DataProviders.shared.usersDataProvider.user(with: currentPost.author) {
                let authorPosts = DataProviders.shared.postsDataProvider.findPosts(by: author.id)
                
                let profileCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileCollectionController") as! ProfileCollectionViewController
                
                profileCollectionViewController.user = author
                profileCollectionViewController.posts = authorPosts
                
                self.navigationController?.pushViewController(profileCollectionViewController, animated: true)
            }
        }
    }
    
    private func findPostFromCell(cell: FeedTableViewCell) -> Post? {
        if let indexPath = tableView.indexPath(for: cell) {
            let currentPost = DataProviders.shared.postsDataProvider.feed()[indexPath.row]
            
            return currentPost
        } else {
            return nil
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUsersFromFeed" {
            let usersTableViewController = segue.destination as! UsersTableViewController
            usersTableViewController.users = usersLikedPost
            usersTableViewController.navigationItemTitle = "Likes"
        }
    }
}

//
//  MWTweetTableViewCell.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

protocol TweetTableViewType {
    var tweetLabel: UILabel { get set }
    var usernameLabel: UILabel { get set }
    var profilePictureImageView: UIImageView { get set }
}

class MWTweetTableViewCell: UITableViewCell {
    
    var tweetLabel: UILabel
    var usernameLabel: UILabel
    var profilePictureImageView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.tweetLabel = UILabel()
        self.usernameLabel = UILabel()
        self.profilePictureImageView = UIImageView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellViews = [tweetLabel, usernameLabel, profilePictureImageView]
        
        for view in cellViews {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraintsOnViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraintsOnViews() {
        //Setup the sizing of the profile picture
        profilePictureImageView.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: ( 1.0 / 8.0 ))
        profilePictureImageView.heightAnchor.constraintEqualToAnchor(profilePictureImageView.widthAnchor, multiplier: 1.0) //Equal width and height
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.height / 2 //to be round
        profilePictureImageView.layer.masksToBounds = true
        
        //Layout the profile picture
        profilePictureImageView.leftAnchor.constraintEqualToAnchor( self.leftAnchor , constant: 8)
        profilePictureImageView.topAnchor.constraintEqualToAnchor( self.topAnchor , constant: 8)
        
        //Layout the usernamelabel above the tweet
        usernameLabel.topAnchor.constraintEqualToAnchor(profilePictureImageView.topAnchor, constant: 0.0)
        usernameLabel.leftAnchor.constraintEqualToAnchor(profilePictureImageView.rightAnchor, constant: 8.0)
        usernameLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: 8.0)
        
        //Layout the tweet label below the usernamelabel and to the right of the profile picture
        tweetLabel.topAnchor.constraintEqualToAnchor(usernameLabel.topAnchor, constant: 0.0)
        tweetLabel.leftAnchor.constraintEqualToAnchor(profilePictureImageView.rightAnchor, constant: 8)
        tweetLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: 8)
        tweetLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 8)
        
    }
    
    func setTweetItem(tweet: Tweet) {
        self.tweetLabel.text = tweet.tweet
        self.usernameLabel.text = tweet.user.username
        self.profilePictureImageView.image = tweet.user.profilePicture
    }

}

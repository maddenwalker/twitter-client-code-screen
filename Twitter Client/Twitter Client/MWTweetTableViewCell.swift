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
        //Basic cell setup
        self.userInteractionEnabled = false
        
        let cellViews = [tweetLabel, usernameLabel, profilePictureImageView]
        
        for view in cellViews {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        setupFormattingOfElements()
        addConstraintsOnViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFormattingOfElements() {
        self.tweetLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        self.usernameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        self.tweetLabel.numberOfLines = 0
    }
    
    //MARK: - Working with auto layout
    func addConstraintsOnViews() {
        let margins = self.contentView.layoutMarginsGuide
        
        //Setup the sizing of the profile picture
        profilePictureImageView.widthAnchor.constraintEqualToAnchor(margins.widthAnchor, multiplier: ( 1.0 / 8.0 )).active = true
        profilePictureImageView.heightAnchor.constraintEqualToAnchor(profilePictureImageView.widthAnchor, multiplier: 1.0).active = true //Equal width and height
        
        //Layout the profile picture
        profilePictureImageView.leftAnchor.constraintEqualToAnchor(margins.leftAnchor).active = true
        profilePictureImageView.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        
        //Layout the usernamelabel above the tweet
        usernameLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        usernameLabel.topAnchor.constraintEqualToAnchor(profilePictureImageView.topAnchor, constant: 0.0).active = true
        usernameLabel.leftAnchor.constraintEqualToAnchor(profilePictureImageView.rightAnchor, constant: 8.0).active = true
        usernameLabel.rightAnchor.constraintEqualToAnchor(margins.rightAnchor).active = true
        
        //Layout the tweet label below the usernamelabel and to the right of the profile picture
        tweetLabel.topAnchor.constraintEqualToAnchor(usernameLabel.bottomAnchor, constant: 0.0).active = true
        tweetLabel.leftAnchor.constraintEqualToAnchor(profilePictureImageView.rightAnchor, constant: 8).active = true
        tweetLabel.rightAnchor.constraintEqualToAnchor(margins.rightAnchor).active = true
        
    }
    
    func setTweetItem(tweet: Tweet) {
        self.tweetLabel.text = tweet.tweet
        self.usernameLabel.text = tweet.user.username
        self.profilePictureImageView.image = tweet.user.profilePicture
        roundTheProfileImageView()
    }
    
    //MARK: - Working with layout of the items
    class func heightForTweetItem(tweet: Tweet, andWidth width: CGFloat) -> CGFloat {
        let layoutCell: MWTweetTableViewCell = MWTweetTableViewCell(style: .Default, reuseIdentifier: "layoutCell")
        layoutCell.setTweetItem(tweet)
        layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame))
        
        layoutCell.setNeedsLayout()
        layoutCell.layoutIfNeeded()
        
        let tweetMaxY = CGRectGetMaxY(layoutCell.tweetLabel.frame) + 8
        let profilePicMaxY = CGRectGetMaxY(layoutCell.profilePictureImageView.frame) + 8
        
        return max(tweetMaxY, profilePicMaxY)
    }
    
    //MARK: - Working with drawing of objects 
    func roundTheProfileImageView() {
        self.profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.height / 2 //to be round
        self.profilePictureImageView.layer.masksToBounds = true
    }

}

//
//  MWTweetTableViewCell.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

protocol TweetTableViewType {
    var tweet: String { get }
    var username: String { get }
    var profilePicture: UIImageView { get }
    var since_id: Int { get }
}

class MWTweetTableViewCell: UITableViewCell {
    
    var tweet: String
    var username: String
    var profilePicture: UIImageView
    var since_id: Int
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        <#code#>
    }

}

//
//  Tweet.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/26/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import Foundation

protocol TweetType {
    var tweet: String! { get }
    var user: User! { get }
    var since_id: Int! { get }
}

enum TweetCreationError: ErrorType {
    case InvalidTweet
    case InvalidUser
    case InvalidSinceID
}

class Tweet: NSObject, NSCoding, TweetType {
    
    var tweet: String!
    var user: User!
    var since_id: Int!
    
    init?(tweet: String, user: User, since_id: Int) {
        self.tweet = tweet
        self.user = user
        self.since_id = since_id
        super.init()
    }
    
    convenience init?(initWithDictionary tweetDictionary: Dictionary<String, AnyObject>) {
        guard let tweet = tweetDictionary["tweet"] as? String else { return nil }
        guard let user = tweetDictionary["user"] as? User else { return nil }
        guard let since_id = tweetDictionary["since_id"] as? Int else { return nil }
        
        self.init(tweet: tweet, user: user, since_id: since_id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let tweet = aDecoder.decodeObjectForKey("tweet") as? String else { TweetCreationError.InvalidTweet; return nil}
        guard let user = aDecoder.decodeObjectForKey("user") as? User else { TweetCreationError.InvalidUser; return nil }
        guard let since_id = aDecoder.decodeObjectForKey("since_id") as? Int else { TweetCreationError.InvalidSinceID; return nil }
        
        self.tweet = tweet
        self.user = user
        self.since_id = since_id
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.tweet, forKey: "tweet")
        aCoder.encodeObject(self.user, forKey: "user")
        aCoder.encodeObject(self.since_id, forKey: "since_id")
    }

}

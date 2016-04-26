//
//  Tweet.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/26/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TweetType {
    var tweet: String! { get }
    var user: User! { get }
    var id: Int! { get }
}

enum TweetCreationError: ErrorType {
    case InvalidTweet
    case InvalidUserDictionary
    case InvalidUser
    case InvalidSinceID
}

class Tweet: NSObject, NSCoding, TweetType {
    
    var tweet: String!
    var user: User!
    var id: Int!
    
    init?(tweet: String, user: User, id: Int) {
        self.tweet = tweet
        self.user = user
        self.id = id
        super.init()
    }
    
    convenience init?(initWithDictionary tweetDictionary: NSDictionary) {
        guard let tweet = tweetDictionary["text"] as? String else { print("\(TweetCreationError.InvalidTweet)"); return nil }
        guard let id = tweetDictionary["id"] as? Int else { print("\(TweetCreationError.InvalidSinceID)"); return nil }
        guard let userDictionary = tweetDictionary["user"] as? NSDictionary else { print("\(TweetCreationError.InvalidUserDictionary)"); return nil }
        guard let user = User(initWithDictionary: userDictionary) else { print("\(TweetCreationError.InvalidUser)"); return nil }
        self.init(tweet: tweet, user: user, id: id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let tweet = aDecoder.decodeObjectForKey("text") as? String else { TweetCreationError.InvalidTweet; return nil}
        guard let user = aDecoder.decodeObjectForKey("user") as? User else { TweetCreationError.InvalidUser; return nil }
        guard let id = aDecoder.decodeObjectForKey("id") as? Int else { TweetCreationError.InvalidSinceID; return nil }
        
        self.tweet = tweet
        self.user = user
        self.id = id
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.tweet, forKey: "text")
        aCoder.encodeObject(self.user, forKey: "user")
        aCoder.encodeObject(self.id, forKey: "id")
    }

}

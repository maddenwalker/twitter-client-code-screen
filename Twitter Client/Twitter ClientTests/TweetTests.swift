//
//  TweetTests.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/26/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import XCTest
@testable import Twitter_Client

class TweetTests: XCTestCase {
    
    let profilePicture: UIImage = UIImage(named: "Empty Profile Picture")!
    var testDictionary: Dictionary <String, AnyObject> = [:]
    let tweet = "This is a tweet"
    let since_id = 12345
    var user: User!
    
    override func setUp() {
        super.setUp()
        let testUserDictionary = [ "username" : "test_username",
                           "full_name": "full_name",
                           "profile_picture": profilePicture]
        
        self.user = User(initWithDictionary: testUserDictionary)

        testDictionary = [ "tweet" : tweet,
                           "user" : self.user,
                           "since_id" : since_id]
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTweetCreationWithDirectInit() {
        let tweet = Tweet(tweet: self.tweet, user: self.user, since_id: self.since_id)
        XCTAssert(tweet?.tweet == self.tweet, "Tweet not correct, it should be \(self.tweet) but is \(tweet?.tweet)")
        XCTAssert(tweet?.user == self.user, "User not correct, it is \(tweet?.user)")
        XCTAssert(tweet?.since_id == self.since_id, "Since ID not correct, it should be \(self.since_id) but is \(tweet?.since_id)")
    }
    
    func testUserCreationWithDictionary() {
        let tweet = Tweet(initWithDictionary: testDictionary)
        XCTAssert(tweet?.tweet == self.tweet, "Tweet not correct, it should be \(self.tweet) but is \(tweet?.tweet)")
        XCTAssert(tweet?.user == self.user, "User not correct, it is \(tweet?.user)")
        XCTAssert(tweet?.since_id == self.since_id, "Since ID not correct, it should be \(self.since_id) but is \(tweet?.since_id)")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

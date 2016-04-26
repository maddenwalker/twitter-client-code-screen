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
    var testUserDictionary: Dictionary <String, AnyObject> = [:]
    var testDictionary: Dictionary <String, AnyObject> = [:]
    let tweet = "This is a tweet"
    let id = 12345
    
    override func setUp() {
        super.setUp()
        testUserDictionary = [ "screen_name" : "test_username",
                           "name": "full_name"]

        testDictionary = [ "text" : tweet,
                           "user" : testUserDictionary,
                           "id" : id]
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTweetCreationWithDirectInit() {
        let user = User(initWithDictionary: testUserDictionary)
        let tweet = Tweet(tweet: self.tweet, user: user!, id: self.id)
        XCTAssert(tweet?.tweet == self.tweet, "Tweet not correct, it should be \(self.tweet) but is \(tweet?.tweet)")
        XCTAssert(tweet?.user == user, "User not correct, it is \(tweet?.user)")
        XCTAssert(tweet?.id == self.id, "Since ID not correct, it should be \(self.id) but is \(tweet?.id)")
    }
    
    func testUserCreationWithDictionary() {
        let tweet = Tweet(initWithDictionary: testDictionary)
        XCTAssert(tweet?.tweet == self.tweet, "Tweet not correct, it should be \(self.tweet) but is \(tweet?.tweet)")
        XCTAssert(tweet?.user.fullName == "full_name", "User not correct, it is \(tweet?.user.fullName)")
        XCTAssert(tweet?.id == self.id, "ID not correct, it should be \(self.id) but is \(tweet?.id)")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

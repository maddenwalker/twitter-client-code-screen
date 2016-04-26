//
//  TestUser.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit
import XCTest
@testable import Twitter_Client

class UserTests: XCTestCase {
    
    var testDictionary: Dictionary <String, AnyObject> = [:]
    let profilePicture: UIImage = UIImage(named: "Empty Profile Picture")!
    
    override func setUp() {
        super.setUp()
        
        testDictionary = [ "screen_name" : "test_username",
                           "name": "full_name",
                           "profile_picture": profilePicture]

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUserCreationWithDirectInit() {
        let user = User(username: "test_username", fullName: "full_name", profilePicture: profilePicture)
        XCTAssert(user?.username == "test_username", "Username not correct, it should be test_username but is \(user?.username)")
        XCTAssert(user?.fullName == "full_name", "Full name not correct, it should be full_name but is \(user?.fullName)")
        XCTAssert(user?.profilePicture == UIImage(named: "Empty Profile Picture")!, "Profile picture not correct, it should be \(profilePicture) but is \(user?.profilePicture)")
    }
    
    func testUserCreationWithDictionary() {
        let user = User(initWithDictionary: testDictionary)
        XCTAssert(user?.username == "test_username", "Username not correct, it should be test_username but is \(user?.username)")
        XCTAssert(user?.fullName == "full_name", "Full name not correct, it should be full_name but is \(user?.fullName)")
        XCTAssert(user?.profilePicture == UIImage(named: "Empty Profile Picture")!, "Profile picture not correct, it should be \(profilePicture) but is \(user?.profilePicture)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

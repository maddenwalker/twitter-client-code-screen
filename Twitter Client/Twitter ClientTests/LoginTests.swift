//
//  LoginTests.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import XCTest
@testable import Twitter_Client

class LoginTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogout() {
        DataSource.sharedInstance.logUserOut(nil)
        XCTAssert(DataSource.sharedInstance.userLoggedIn == false, "The user should not be considered logged in")
        XCTAssert(DataSource.sharedInstance.tweetItems.count == 0, "There should not be any tweet items when the user logs out")
    }
    
    func testLogin() {
        DataSource.sharedInstance.logUserIn(withUsername: "test_user")
        XCTAssert(DataSource.sharedInstance.userLoggedIn == true, "The user should be considered logged in")
        XCTAssert(DataSource.sharedInstance.tweetItems.count != 0, "There should tweet items when the user logs in")
    }
    
    
}

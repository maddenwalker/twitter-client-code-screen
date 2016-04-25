//
//  LoginTests.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import XCTest
import KeychainAccess
@testable import Twitter_Client

class LoginTests: XCTestCase {
    let keychain = Keychain(service: "com.maddenwalker.twitter-client")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //These tests will not pass cocurrently as the app is required to be restarted as the keychain is altered on load and analyzed
    func testNoAccessToken() {
        keychain["access token"] = nil
        let accessToken = keychain["access token"]
        XCTAssert(DataSource.sharedInstance.userLoggedIn == false, "The user should not be considered logged in when there is no access token; in this case the access token is: \(accessToken)")
    }
    
    func testAccessTokenPresent() {
        keychain["access token"] = "sometesttokentoshowweareloggedin"
        let accessToken = keychain["access token"]
        XCTAssert(DataSource.sharedInstance.userLoggedIn == true, "The user should not be considered logged in when there is no access token; in this case the access token is: \(accessToken)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

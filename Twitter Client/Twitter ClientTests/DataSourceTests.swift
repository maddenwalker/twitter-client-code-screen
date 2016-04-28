//
//  DataSourceTests.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/26/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Twitter_Client

class DataSourceTests: XCTestCase {
    
    var jsonArray: [Dictionary<String,AnyObject>]?
    var filePath = NSBundle.mainBundle().pathForResource("example_data", ofType: "json")
    var json: JSON?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONIngestion() {
        do {
            json = try DataSource.sharedInstance.loadData(fromFilePath: filePath!)!
            let screen_name = json![0]["user"]["screen_name"]
            XCTAssert(screen_name == "OldGREG85", "The JSON data is not being parsed correctly, you are returning \(screen_name)")
        } catch {
            print("something went wrong")
        }
    }
    
    func testDictionaryParsing() {
        do {
        if let json = self.json {
            let dictionaryArray = try DataSource.sharedInstance.parseJSONIntoDictionaryArray(json)
            let screen_name = dictionaryArray![0]["user"]!["screen_name"]
            XCTAssert( screen_name == "OldGREG85", "The dictionary is not correct, you are returning \(screen_name)")
            }
        } catch {
            print("This is why we test, to catch errors")
        }
    }
    
}

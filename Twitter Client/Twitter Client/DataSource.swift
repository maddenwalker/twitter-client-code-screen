//
//  DataSource.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import KeychainAccess

enum DataSourceError: ErrorType {
    case CannotReadData
    case CannotReadElementInJSON
}

class DataSource: NSObject {

    var tweetItems: [Tweet] = []
    static let sharedInstance = DataSource()
    
    var userLoggedIn: Bool = false
    var keychain: Keychain
    
    //Don't let others access this init
    private override init() {
        keychain = Keychain(service: "com.maddenwalker.twitter-client")
        
        super.init()
        
        if ( keychain["access token"] != nil ) {
            userLoggedIn = true
            //Load existing tweets
            if let fullPath = pathForFileName("tweetItems") {
                if let savedTweets = NSKeyedUnarchiver.unarchiveObjectWithFile(fullPath) as? [Tweet] {
                    if savedTweets.count > 0 {
                        self.tweetItems = savedTweets
                        //TODO: Request new items here
                    }
                }
            }
            
            } else {
            userLoggedIn = false
            self.registerForAccessToken()
        }
    }
    
    //MARK: Notification Center
    func registerForAccessToken() {
        NSNotificationCenter.defaultCenter().addObserverForName(LoginViewControllerDidGetAccessTokenNotification, object: nil, queue: nil) { (_) in
            //In a normal instance I would look for the variable passed here and set that as the access token so we could access that globally
            self.keychain["access token"] = "somerandomstringthatisservingasouraccesstokenfornowuntilwefullyimplement"
            self.userLoggedIn = true
            self.loadDummyData()
        }
    }
    
    func resetUserLoggedInBool() {
        userLoggedIn = !userLoggedIn
    }
    
    func logUserOut(completion: () -> Void ) {
        self.keychain["access token"] = nil
        self.userLoggedIn = false
        if let filePath = pathForFileName("tweetItems") {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filePath)
            } catch {
                print("Could not delete your data for some reason; error: \(error)")
            }
        }
        completion()
    }
    
    //MARK: - Working with Data
    func fetchNewItems(completion: () -> ()) {
        
    }
    
    //Simple function to load dummy data here; would be replaced with networking call off main thread
    func loadDummyData() {
        if let JSONFilePath = NSBundle.mainBundle().pathForResource("example_data", ofType: "json") {
            do {
                guard let json = try self.loadData(fromFilePath: JSONFilePath) else { return }
                guard let dictionaryArray = try self.parseJSONIntoDictionaryArray(json) else { return }
                self.parseDictionaryArrayIntoTweets(dictionaryArray)
                self.saveItems()
            } catch {
                print("\(error)")
            }
        }
    }
    
    func loadData(fromFilePath filePath: String) throws -> JSON? {
        guard let jsonData = NSData(contentsOfFile: filePath) else { DataSourceError.CannotReadData; return nil }
        return JSON(data: jsonData)
    }
    
    func parseJSONIntoDictionaryArray(json: JSON) throws -> [Dictionary<String, AnyObject>]? {
        guard let dictionaryArray = json.rawValue as? [Dictionary<String, AnyObject>] else { DataSourceError.CannotReadElementInJSON; return nil }
        return dictionaryArray
    }

    func parseDictionaryArrayIntoTweets(dictionaryArray: [Dictionary<String, AnyObject>]) {
        for dictionary in dictionaryArray {
            let tweet: Tweet = Tweet(initWithDictionary: dictionary)!
            tweetItems.append(tweet)
        }
    }
    
    func saveItems() {
        if tweetItems.count > 0 {
            //Save these to disk
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                let numberOfItemsToSave = min(self.tweetItems.count, 50)
                let itemsToSave = Array(self.tweetItems[0..<numberOfItemsToSave])
                guard let fullPath: String = self.pathForFileName("tweetItems") else { return }
                NSKeyedArchiver.archiveRootObject(itemsToSave, toFile: fullPath)
            })
        }
    }
    
    //MARK: - Working with the file system
    
    func pathForFileName(filename: String) -> String? {
        let paths: Array = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        guard let documentsDirectory: String = paths[0] else { return nil }
        let dataPath = documentsDirectory + filename
        return dataPath
    }
}

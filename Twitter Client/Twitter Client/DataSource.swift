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

//NOTE: I chose this as opposed to KVO because of the inherent one-to-one communication required
protocol DataSourceDelegate {
    func tweetItemsDidChange()
}

class DataSource: NSObject {

    var tweetItems: [Tweet] = []
    static let sharedInstance = DataSource()
    
    var currentUser: User?
    var userLoggedIn: Bool = false
    var keychain: Keychain
    
    var delegate: DataSourceDelegate?
    
    //Don't let others access this init
    private override init() {
        keychain = Keychain(service: "com.maddenwalker.twitter-client")
        
        super.init()
        
        if ( keychain["access token"] != nil ) {
            userLoggedIn = true
            loadUserData()
        } else {
            userLoggedIn = false
        }
    }
    
    //MARK: - Logging user in Methods
    
    func logUserIn(withUsername username: String) {
        self.keychain["access token"] = "somerandomstringthatisservingasouraccesstokenfornowuntilwefullyimplement"
        self.userLoggedIn = true
        createLoggedInUserWithName(username)
        self.saveUserInfo()
        self.loadDummyData()
        self.delegate?.tweetItemsDidChange()
    }
    
    //MARK: - Working with logged in user
    func loadUserData() {
        if let userFilePath = pathForFileName("userItem") {
            if let user = NSKeyedUnarchiver.unarchiveObjectWithFile(userFilePath) as? User {
                self.currentUser = user
            }
        }
        
        //Load existing tweets
        if let tweetFilePath = pathForFileName("tweetItems") {
            if let savedTweets = NSKeyedUnarchiver.unarchiveObjectWithFile(tweetFilePath) as? [Tweet] {
                if savedTweets.count > 0 {
                    self.tweetItems = savedTweets
                    self.fetchNewItems(nil)
                }
            }
        }
    }
    
    //MARK: - Logout Methods
    func logUserOut(completion: (() -> ())? ) {
        self.keychain["access token"] = nil
        self.userLoggedIn = false
        self.tweetItems = []
        self.currentUser = nil
        deleteUserData()
        delegate?.tweetItemsDidChange()
        if let completion = completion {
            completion()
        }
    }
    
    func deleteUserData() {
        if let tweetFilePath = pathForFileName("tweetItems") {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(tweetFilePath)
            } catch {
                print("Could not delete your data for some reason; error: \(error)")
            }
        }
        
        if let userFilePath = pathForFileName("userItem") {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(userFilePath)
            } catch {
                print("Could not delete your data for some reason; error: \(error)")
            }
        }
    }
    
    //MARK: - Updating User State Methods
    func updateCurrentUserWith(image: UIImage) {
        self.currentUser?.profilePicture = image
        self.delegate?.tweetItemsDidChange()
        saveUserInfo()
        saveItems()
    }
    
    
    //MARK: - Creation of new Tweet Methods
    func createTweetWithText(text: String, withUser user: User) {
        //This is a hack as the server would add this
        var newID: Int = 0
        if let id = self.tweetItems.first?.id {
            newID = id + 1
        } else {
            newID += newID
        }
        if let currentUser = self.currentUser {
            if let tweet = Tweet(tweet: text, user: currentUser, id: newID) {
                submitNewItems(tweet, completion: {
                    self.delegate?.tweetItemsDidChange()
                })
            }
        }
    }
    
    //MARK: - Working with Data
    func fetchNewItems(completion: (() -> ())?) {
        //Normally I would query the API here in a separate class.  For the purposes of this dummy client, I will simply query the file system repeatedly and load the example new tweet; I would also only use the since_id parameter to fetch only tweets that are newer than what we have already
        if self.tweetItems.count > 0 {
            //They are already sorted so I just grab the first in the stack
            if let mostRecentID = self.tweetItems[0].id {
                loadNewTweetWithIDGreaterThan(mostRecentID)
            }
        }
        
        completion?()
        
    }
    
    func submitNewItems(tweet: Tweet, completion: (() -> ())?) {
        //This is a hack because we would not submit directly to our data source, I would submit to the API, then call a refresh
        self.tweetItems.append(tweet)
        sortArrayOfTweets()
        saveItems()
        if let completion = completion {
            completion()
        }
    }
    
    func loadNewTweetWithIDGreaterThan(id: Int) {
        //This is such a hack and sorry for lack of anything cool here.  The ID stays constant as it is generated from the json table.  That means if you tweet after loading this, your tweet will always show on top (the ID will then always be 1 greater)
        if let JSONFilePath = NSBundle.mainBundle().pathForResource("example_new_data", ofType: "json") {
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
    
    func sortArrayOfTweets() {
        //This is a good place to sort the data
        self.tweetItems.sortInPlace({ (tweet1, tweet2) -> Bool in
            return tweet1.id > tweet2.id
        })
    }
    
    //MARK: - Creating Dummmy Data and User
    
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
    
    func createLoggedInUserWithName(username: String) {
        self.currentUser = User(username: username, fullName: "You", profilePicture: UIImage(named: "Empty Profile Picture")!)
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
        sortArrayOfTweets()
    }
    
    
    //MARK: - Working with the file system
    
    func pathForFileName(filename: String) -> String? {
        let paths: Array = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        guard let documentsDirectory: String = paths[0] else { return nil }
        let dataPath = documentsDirectory + "/\(filename)"
        return dataPath
    }
    
    
    func saveUserInfo() {
        if let user = self.currentUser {
            if let filePath = pathForFileName("userItem") {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    NSKeyedArchiver.archiveRootObject(user, toFile: filePath)
                })
            }
        }
    }
    
    
    //!!!: When I reload these items back into memory they don't retain the original reference to the instance of the current user.  I am not sure why.
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
    
 }

//
//  DataSource.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit
import Foundation
import KeychainAccess

class DataSource: NSObject {
    
    static let sharedInstance = DataSource()
    
    var userLoggedIn: Bool = false
    var keychain: Keychain
    
    //Don't let others access this init
    private override init() {
        keychain = Keychain(service: "com.maddenwalker.twitter-client")
        
        super.init()
        
        if ( keychain["access token"] != nil ) {
            userLoggedIn = true
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
        }
    }
    
    func resetUserLoggedInBool() {
        userLoggedIn = !userLoggedIn
    }
    
    func logUserOut(completion: () -> Void ) {
        self.keychain["access token"] = nil
        self.userLoggedIn = false
        completion()
    }

    
}

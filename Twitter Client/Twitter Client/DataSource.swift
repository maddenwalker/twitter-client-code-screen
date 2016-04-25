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
    
    func registerForAccessToken() {
        NSNotificationCenter.defaultCenter().addObserverForName(LoginViewControllerDidGetAccessTokenNotification, object: nil, queue: nil) { (_) in
            self.keychain["access token"] = "somerandomstringthatisservingasouraccesstokenfornowuntilwefullyimplement"
        }
    }
    
}

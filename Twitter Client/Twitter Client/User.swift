//
//  User.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

enum UserCreationError: ErrorType {
    case InvalidUsername
    case InvalidFullname
    case InvalidProfilePicture
    case InitializationFromCoderInvalid
}

protocol UserType {
    var username: String { get }
    var fullName: String { get }
    var profilePicture: UIImage { get }
}

class User: NSObject, NSCoding, UserType {
    var username: String
    var fullName: String
    var profilePicture: UIImage
    
    init?(username: String, fullName: String, profilePicture: UIImage) {
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
//        super.init()
    }
    
    convenience init?(initWithDictionary userDictionary: NSDictionary) {
        guard let username = userDictionary["screen_name"] as? String else { UserCreationError.InvalidUsername; return nil}
        guard let fullName = userDictionary["name"] as? String else { UserCreationError.InvalidFullname; return nil }
        //Initializing with dummy data here; would normally request image from API using NSURL 
        guard let profilePicture = UIImage(named: "Empty Profile Picture") else { UserCreationError.InvalidProfilePicture; return nil }
        
        self.init(username: username, fullName: fullName, profilePicture: profilePicture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObjectForKey("screen_name") as? String else { UserCreationError.InitializationFromCoderInvalid; return nil}
        guard let fullName = aDecoder.decodeObjectForKey("name") as? String else { UserCreationError.InitializationFromCoderInvalid; return nil }
        guard let profilePicture = aDecoder.decodeObjectForKey("profile_picture") as? UIImage else { UserCreationError.InitializationFromCoderInvalid; return nil }
        
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.username, forKey: "screen_name")
        aCoder.encodeObject(self.fullName, forKey: "name")
        aCoder.encodeObject(self.profilePicture, forKey: "profile_picture")
    }

}



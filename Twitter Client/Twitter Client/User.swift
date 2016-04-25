//
//  User.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import Foundation
import UIKit

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
    
    init(username: String, fullName: String, profilePicture: UIImage) {
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObjectForKey("username") as? String else { UserCreationError.InitializationFromCoderInvalid; return nil}
        guard let fullName = aDecoder.decodeObjectForKey("fullName") as? String else { UserCreationError.InitializationFromCoderInvalid; return nil }
        guard let profilePicture = aDecoder.decodeObjectForKey("username") as? UIImage else { UserCreationError.InitializationFromCoderInvalid; return nil }
        
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.fullName, forKey: "fullName")
        aCoder.encodeObject(self.profilePicture, forKey: "profilePicture")
    }
}



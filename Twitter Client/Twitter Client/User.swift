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

protocol UserType {
    var username: String { get }
    var fullName: String { get }
    var profilePicture: UIImage { get }
}

private enum SerializationKeys: String {
    case Username
    case Name
    case ProfilePicture
}

enum UserCreationError: ErrorType {
    case InvalidUsername
    case InvalidFullname
    case InvalidProfilePicture
    case InitializationFromCoderInvalid
}

class User: NSObject, NSCoding, UserType {
    var username: String
    var fullName: String
    var profilePicture: UIImage
    
    init?(username: String, fullName: String, profilePicture: UIImage) {
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
        super.init()
    }
    
    convenience init?(initWithDictionary userDictionary: NSDictionary) {
        guard let username = userDictionary["screen_name"] as? String else { UserCreationError.InvalidUsername; return nil}
        guard let fullName = userDictionary["name"] as? String else { UserCreationError.InvalidFullname; return nil }
        //Initializing with dummy data here; would normally store URL to image and then request image from API before storing; I would however still have a default picture in the event that I am not able to find a picture
        guard let profilePicture = UIImage(named: "Empty Profile Picture") else { UserCreationError.InvalidProfilePicture; return nil }
        
        self.init(username: username, fullName: fullName, profilePicture: profilePicture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObjectForKey(SerializationKeys.Username.rawValue) as? String else { UserCreationError.InitializationFromCoderInvalid; return nil}
        guard let fullName = aDecoder.decodeObjectForKey(SerializationKeys.Name.rawValue) as? String else { UserCreationError.InitializationFromCoderInvalid; return nil }
        guard let profilePicture = aDecoder.decodeObjectForKey(SerializationKeys.ProfilePicture.rawValue) as? UIImage else { UserCreationError.InitializationFromCoderInvalid; return nil }
        
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.username, forKey: SerializationKeys.Username.rawValue)
        aCoder.encodeObject(self.fullName, forKey: SerializationKeys.Name.rawValue)
        aCoder.encodeObject(self.profilePicture, forKey: SerializationKeys.ProfilePicture.rawValue)
    }

}



//
//  User.swift
//  RealtimeChat
//
//  Created by Hyeongjin Um on 22/07/2017.
//  Copyright © 2017 Hyeongjin Um. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    var id: String?
    var name: String
    var email: String
    var profileImageURL: String?
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageURL = dictionary["imageURL"] as? String ?? ""
    }
}

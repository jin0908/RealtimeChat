//
//  Message.swift
//  RealtimeChat
//
//  Created by Hyeongjin Um on 22/07/2017.
//  Copyright © 2017 Hyeongjin Um. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    
    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    
    init(dictionary: [String: Any]) {
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? NSNumber ?? 0
        self.toID = dictionary["toID"] as? String ?? ""

    }
    
    func chatPartnerId() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}

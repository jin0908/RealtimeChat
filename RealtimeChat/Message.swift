//
//  Message.swift
//  RealtimeChat
//
//  Created by Hyeongjin Um on 22/07/2017.
//  Copyright © 2017 Hyeongjin Um. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var fromID: String?
    var text: String?
    var timestamp: String?
    var toID: String?
    
    init?(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
    }
    
    
}

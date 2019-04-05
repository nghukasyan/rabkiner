//
//  Message.swift
//  Rabkiner
//
//  Created by MacBook Air on 4/4/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}

//
//  ChatRoom.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/14.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import Foundation
import Firebase

class ChatRoom {
    
    let latestMessageId: String
    let memebers: [String]
    let createdAt: Timestamp
    
    var partnerUser: User?
    var documentId: String?
    
    init(dic: [String: Any]) {
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.memebers = dic["memebers"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}

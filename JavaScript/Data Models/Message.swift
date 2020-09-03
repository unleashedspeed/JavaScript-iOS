//
//  Message.swift
//  JavaScript
//
//  Created by Saurabh Gupta on 03/09/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import Foundation

struct Message: Codable {
    let id: String?
    let type: MessageType?
    let state: State?
    let progress: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, state, progress
        case type = "message"
    }
    
    enum MessageType: String, Codable {
        case progress
        case completed
    }
    
    enum State: String, Codable {
        case started
        case error
        case success
    }
    
}

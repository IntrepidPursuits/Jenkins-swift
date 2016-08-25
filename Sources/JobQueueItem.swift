//
//  JobQueueItem.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 8/23/16.
//
//

import Foundation

public final class JobQueueItem {
    private(set) var blocked: Bool?
    private(set) var buildable: Bool?
    private(set) var buildableStartTime: Int?
    private(set) var identifier: Int?
    private(set) var timeSinceQueue: Int?
    private(set) var parameters: String?
    private(set) var isStuck: Bool?
    private(set) var taskName: String?
    private(set) var taskURL: String?
    private(set) var queueReason: String?
    
    init(json: JSON) {
        guard let identifier = json["identifier"] as? Int else {
            self.identifier = 0
            return
        }
        
        self.identifier = identifier
        self.blocked = json["blocked"] as? Bool
        self.buildable = json["buildable"] as? Bool
    }
}

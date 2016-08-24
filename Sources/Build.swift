//
//  Build.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 8/18/16.
//
//

import Foundation

public enum BuildResult {
    case Success
    case Failed
    case Aborted
    case Unknown
    
    private init(type: String?) {
        guard let type = type else {
            self = .Unknown
            return
        }
        
        switch type {
        case "SUCCESS":
            self = .Success
        case "FAILURE":
            self = .Failed
        case "ABORTED":
            self = .Aborted
        default:
            self = .Unknown
        }
    }
}

public struct Build {
    private(set) var identifier: Int = 0
    private(set) var buildNumber: Int = 0
    private(set) var buildDescription: String = ""
    private(set) var displayName: String = ""
    private(set) var duration: Int = 0
    private(set) var estimatedDuration: Int = 0
    private(set) var executor: String = ""
    private(set) var fullDisplayName: String = ""
    private(set) var keepLog: Bool = false
    private(set) var queueIdentifier: Int = 0
    private(set) var result: BuildResult = .Unknown
    private(set) var timestamp: Int = 0
    private(set) var url: String = ""
    
    init(json: JSON) {
        guard let identifier = Int(json["id"] as! String) else {
            self.identifier = 0
            return
        }
        
        self.identifier = identifier
        self.buildNumber = json["number"] as? Int ?? 0
        self.buildDescription = json["description"] as? String ?? ""
        self.displayName = json["displayName"] as? String ?? ""
        self.duration = json["duration"] as? Int ?? 0
        self.estimatedDuration = json["estimatedDuration"] as? Int ?? 0
        self.executor = json["executor"] as? String ?? ""
        self.fullDisplayName = json["fullDisplayName"] as? String ?? ""
        self.keepLog = json["keepLog"] as? Bool ?? false
        self.queueIdentifier = json["queueId"] as? Int ?? 0
        
        let buildResult = json["result"] as? String ?? ""
        self.result = BuildResult(type: buildResult)
        self.timestamp = json["timestamp"] as? Int ?? 0
        self.url = json["url"] as? String ?? ""
    }
}

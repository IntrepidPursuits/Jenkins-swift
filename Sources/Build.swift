//
//  Build.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 8/18/16.
//
//

import Foundation

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
        guard let buildNum = json["number"] as? Int else {
            self.buildNumber = 0
            return
        }
        
        self.buildNumber = buildNum
        
        if let id = json["id"] as? String {
            self.identifier = Int(id) ?? 0
        }
        
        if let description = json["description"] as? String {
            self.buildDescription = description
        }
        
        if let displayName = json["displayName"] as? String {
            self.displayName = displayName
        }
        
        if let duration = json["duration"] as? Int {
            self.duration = duration
        }
        
        if let estimatedDuration = json["estimatedDuration"] as? Int {
            self.estimatedDuration = estimatedDuration
        }
        
        if let executor = json["executor"] as? String {
            self.executor = executor
        }
        
        if let fullDisplayName = json["fullDisplayName"] as? String {
            self.fullDisplayName = fullDisplayName
        }
        
        if let keepLog = json["keepLog"] as? Bool {
            self.keepLog = keepLog
        }
        
        if let queueID = json["queueId"] as? Int {
            self.queueIdentifier = queueID
        }
        
        if let result = json["result"] as? String {
            self.result = BuildResult(type: result)
        }
        
        if let timestamp = json["timestamp"] as? Int {
            self.timestamp = timestamp
        }
        
        if let url = json["url"] as? String {
            self.url = url
        }
    }
}

// MARK: Build Result

public enum BuildResult {
    case Success
    case Failed
    case Aborted
    case Unknown
    
    init(type: String?) {
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

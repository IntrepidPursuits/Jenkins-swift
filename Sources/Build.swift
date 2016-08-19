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
        self.identifier = Int(json["id"] as! String) ?? 0
    }
}

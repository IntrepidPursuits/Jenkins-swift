//
//  HealthReport.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 8/19/16.
//
//

import Foundation

public struct HealthReport {
    var report: String
    var iconClassName: String
    var score: Int
    
    init(json: JSON) {
        self.report = json["description"] as? String ?? ""
        self.iconClassName = json["iconClassName"] as? String ?? ""
        self.score = json["score"] as? Int ?? 0
    }
}

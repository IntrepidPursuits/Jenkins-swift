//
//  Errors.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 8/24/16.
//
//

import Foundation

public enum JenkinsError: Error {
    case InvalidJenkinsHost
    case InvalidJenkinsURL
    case UnknownError
    
    init(error: APIError) {
        switch error {
        case .InvalidHost:
            self = .InvalidJenkinsHost
        default:
            self = .UnknownError
        }
    }
}

extension JenkinsError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .InvalidJenkinsHost:   return "Couldn't connect to Jenkins Host"
        case .UnknownError:         return "Unknown error"
        case .InvalidJenkinsURL:    return "Malformed Jenkins URL"
        }
    }
}

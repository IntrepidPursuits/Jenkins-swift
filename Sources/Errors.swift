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
    case JobRequiresParameters
    case NotAuthorized
    case NotFound
    case UnknownError
    
    init(error: APIError) {
        switch error {
        case .InvalidHost:
            self = .InvalidJenkinsHost
        default:
            self = .UnknownError
        }
    }
    
    init(httpStatusCode: Int) {
        switch httpStatusCode {
        case 400:
            self = .JobRequiresParameters
        case 404:
            self = .NotFound
        case 403:
            self = .NotAuthorized
        default:
            self = .UnknownError
        }
    }
}

extension JenkinsError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .InvalidJenkinsHost:   	return "Couldn't connect to Jenkins Host"
        case .InvalidJenkinsURL:    	return "Malformed Jenkins URL"
        case .JobRequiresParameters:    return "Job requires parameters to build"
        case .NotAuthorized:            return "Session not authorized"
        case .NotFound:                 return "Resource not found"
        case .UnknownError:             return "Unknown error"
        }
    }
}

//
//  Coverage.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 11/13/16.
//
//

import Foundation

public enum CodeCoverageProvider {
    case Cobertura
    case Jacoco
    case Other(path: String)
    
    func path() -> String {
        switch self {
        case .Cobertura:        return "Cobertura"
        case .Jacoco:           return "jacaco"
        case .Other(let path):  return path
        }
    }
}

public enum CodeCoverageElementType: String {
    case Classes        = "Classes"
    case Conditionals   = "Conditionals"
    case Files          = "Files"
    case Lines          = "Lines"
    case Packages       = "Packages"
    case Unknown        = "Unknown"
    
    init(_ rawValue: String) {
        switch rawValue {
        case "Classes":         self = .Classes
        case "Conditionals":    self = .Conditionals
        case "Files":           self = .Files
        case "Lines":           self = .Lines
        case "Packages":        self = .Packages
        default:                self = .Unknown
        }
    }
}

public struct CodeCoverageElement {
    private(set) var elementType: CodeCoverageElementType = .Unknown
    private(set) var numerator: Int = 0
    private(set) var denominator: Int = 0
    
    init(json: JSON) {
        let coverageElementName: String = json["name"] as? String ?? ""
        elementType = CodeCoverageElementType(coverageElementName)
        numerator = json["numerator"] as? Int ?? 0
        denominator = json["denominator"] as? Int ?? 0
    }
    
    func ratio() -> Double {
        return Double(numerator) / Double(denominator)
    }
}

public struct CodeCoverageReport {
    private(set) var name: String
    private(set) var childReports: [CodeCoverageReport]
    private(set) var coverageElements: [CodeCoverageElement]
    
    init(json: JSON) {
        name = json["name"] as? String ?? ""
        
        // for each child, init self
        let childrenJSON: [JSON] = json["children"] as? [JSON] ?? []
        childReports = childrenJSON
            .filter({ child in
                let elements = child["elements"] as? [JSON] ?? []
                return elements.filter({ $0.count > 0 }).count > 0
            })
            .map({
                CodeCoverageReport(json: $0)
            })
        
        // for each element, init element
        let elementJSON: [JSON] = json["elements"] as? [JSON] ?? []
        coverageElements = elementJSON.map({ CodeCoverageElement(json: $0) })
    }
    
    func lineRatio() -> Double {
        return coverageElements.filter({$0.elementType == .Lines}).first?.ratio() ?? 0
    }
}

/*
 *  Jenkins Extension
 */

extension Jenkins {
    func codeCoverage(_ job: String,
                      build: Int = 0,
                      depth: Int = 2,
                      provider: CodeCoverageProvider = .Cobertura,
                      handler: @escaping (_ coverageReport: CodeCoverageReport?) -> Void)
    {
        let buildPath = (build == 0) ? "lastSuccessfulBuild" : "\(build)"
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(job)
            .appendingPathComponent(buildPath)
            .appendingPathComponent(provider.path())
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
                return handler(nil)
        }
        
        client?.get(path: url) { response, error in
            guard let json = response as? JSON else {
                return handler(nil)
            }
            
            guard let results = json["results"] as? JSON else {
                return handler(nil)
            }
            
            handler(CodeCoverageReport(json: results))
        }
    }
    
    func codeCoverage(_ job: Job,
                      build: Int = 0,
                      depth: Int = 2,
                      provider: CodeCoverageProvider = .Cobertura,
                      handler: @escaping (_ coverageReport: CodeCoverageReport?) -> Void)
    {
        codeCoverage(job.name, build: build, depth: depth, provider: provider, handler: handler)
    }
}

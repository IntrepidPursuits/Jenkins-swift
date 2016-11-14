//
//  Coverage.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 11/13/16.
//
//

import Foundation

public enum CoberturaCodeCoverageElementType: String {
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

public struct CoberturaCodeCoverageElement {
    private(set) var elementType: CoberturaCodeCoverageElementType = .Unknown
    private(set) var covered: Int = 0
    private(set) var total: Int = 0
    
    init(json: JSON) {
        let coverageElementName: String = json["name"] as? String ?? ""
        elementType = CoberturaCodeCoverageElementType(coverageElementName)
        covered = json["numerator"] as? Int ?? 0
        total = json["denominator"] as? Int ?? 0
    }
    
    func ratio() -> Double {
        return Double(covered) / Double(total)
    }
}

public struct CoberturaCodeCoverageReport {
    private(set) var name: String
    private(set) var childReports: [CoberturaCodeCoverageReport]
    private(set) var coverageElements: [CoberturaCodeCoverageElement]
    
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
                CoberturaCodeCoverageReport(json: $0)
            })
        
        // for each element, init element
        let elementJSON: [JSON] = json["elements"] as? [JSON] ?? []
        coverageElements = elementJSON.map({ CoberturaCodeCoverageElement(json: $0) })
    }
    
    func ratio(of element: CoberturaCodeCoverageElementType) -> Double {
        return coverageElements.filter({$0.elementType == element}).first?.ratio() ?? 0
    }
}

/*
 *  Jenkins Cobertura Extension
 */

extension Jenkins {
    func coberturaCoverage(_ job: String,
                      build: Int = 0,
                      depth: Int = 2,
                      handler: @escaping (_ coverageReport: CoberturaCodeCoverageReport?) -> Void)
    {
        let buildPath = (build == 0) ? "lastSuccessfulBuild" : String(build)
        
        guard let url: URL = URL(string: jobURL)?
            .appendingPathComponent(job)
            .appendingPathComponent(buildPath)
            .appendingPathComponent("cobertura")
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
                return handler(nil)
        }
        
        let parameters: [String : AnyObject] = ["depth" : depth as AnyObject]
        client?.get(path: url, params: parameters) { response, error in
            guard let json = response as? JSON,
                let results = json["results"] as? JSON else {
                    return handler(nil)
            }
            
            handler(CoberturaCodeCoverageReport(json: results))
        }
    }
    
    func coberturaCoverage(_ job: Job,
                      build: Int = 0,
                      depth: Int = 2,
                      handler: @escaping (_ coverageReport: CoberturaCodeCoverageReport?) -> Void)
    {
        coberturaCoverage(job.name, build: build, depth: depth, handler: handler)
    }
}

//
//  JacacoCoverage.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 11/13/16.
//
//

import Foundation

public enum JacocoCodeCoverageElementType: CoverageElementType {
    case BranchCoverage
    case ClassCoverage
    case ComplexityCoverage
    case InstructionCoverage
    case LineCoverage
    case MethodCoverage
    case Unknown
    
    init(_ rawValue: String) {
        switch rawValue {
        case "branchCoverage":      self = .BranchCoverage
        case "classCoverage":       self = .ClassCoverage
        case "complexityScore":     self = .ComplexityCoverage
        case "instructionCoverage": self = .InstructionCoverage
        case "lineCoverage":        self = .LineCoverage
        case "methodCoverage":      self = .MethodCoverage
        default: self = .Unknown
        }
    }
}

public struct JacocoCodeCoverageElement: CoverageElement {
    public var elementType: CoverageElementType
    public var covered: Int
    public var total: Int
}

public struct JacocoCodeCoverageReport {
    private(set) var name: String
    private(set) var coverageElements: [JacocoCodeCoverageElement]
    
    init(json: JSON) {
        let elementCoveredKey = "covered"
        let elementTotalKey = "total"
        
        name = json["_class"] as? String ?? "Jacoco Report"
        var elements: [JacocoCodeCoverageElement] = []
        
        for (key, coverage) in json {
            let elemType = JacocoCodeCoverageElementType(key)
            if elemType != .Unknown {
                let covered = coverage[elementCoveredKey] as? Int ?? 0
                let total = coverage[elementTotalKey] as? Int ?? 0
                let elem = JacocoCodeCoverageElement(elementType: elemType, covered: covered, total: total)
                elements.append(elem)
            }
        }
        
        self.coverageElements = elements
    }
    
    public func ratio(of element: CoverageElementType) -> Double {
        if let e = element as? JacocoCodeCoverageElementType {
            return coverageElements.filter({$0.elementType as? JacocoCodeCoverageElementType == e}).first?.ratio() ?? 0
        }
        return 0
    }
}

/*
 *  Jenkins Cobertura Extension
 */

extension Jenkins {
    public func jacocoCoverage(_ job: String,
                           build: Int = 0,
                           handler: @escaping (_ coverageReport: JacocoCodeCoverageReport?) -> Void)
    {
        let buildPath = (build == 0) ? "lastSuccessfulBuild" : String(build)
        
        guard let url: URL = URL(string: jobURL)?
            .appendingPathComponent(job)
            .appendingPathComponent(buildPath)
            .appendingPathComponent("jacoco")
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
                return handler(nil)
        }
        
        client?.get(path: url) { response, error in
            guard let json = response as? JSON else {
                    return handler(nil)
            }
            
            handler(JacocoCodeCoverageReport(json: json))
        }
    }
    
    public func jacocoCoverage(_ job: Job,
                           build: Int = 0,
                           depth: Int = 0,
                           handler: @escaping (_ coverageReport: JacocoCodeCoverageReport?) -> Void)
    {
        jacocoCoverage(job.name, build: build, handler: handler)
    }
}

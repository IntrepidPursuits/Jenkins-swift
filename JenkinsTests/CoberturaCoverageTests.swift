//
//  CoberturaCoverageTests.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 11/13/16.
//
//

import Foundation
import XCTest
@testable import Jenkins

class CoberturaCoverageTests: XCTestCase {
    
    func testCoberturaCodeCoverageDepth2() {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "CoverageReportDepth2", ofType: "json") else {
            return XCTFail("Missing Coverage Report JSON")
        }
        
        guard
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped),
            let json: JSON = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSON
            else {
                return XCTFail("Failed mapping Coverage Report JSON")
        }
        
        let c = CoberturaCodeCoverageReport(json: json["results"] as! JSON)
        
        let validChildren = 0
        XCTAssert(c.childReports.count == validChildren, "Report has \(c.childReports.count) children, but should have \(validChildren)")
        
        let validName = "Cobertura Coverage Report"
        XCTAssert(c.name.compare(validName) == ComparisonResult.orderedSame, "Coverage report name is '\(c.name)' but should be \(validName)")
        
        let validCovElements = 5
        XCTAssert(c.coverageElements.count == validCovElements, "Report has \(c.coverageElements.count) coverage elements but should have \(validCovElements)")
        
        let validLineRatio = 0.2
        let actualLineRatio = c.ratio(of: .Lines)
        XCTAssertEqualWithAccuracy(actualLineRatio, validLineRatio, accuracy: 0.05, "Ratio is \(actualLineRatio) but should be \(validLineRatio)")
    }
    
    func testCoberturaCodeCoverageDepth3() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "CoverageReportDepth3", ofType: "json") else {
            return XCTFail("Missing Coverage Report JSON")
        }
        
        guard
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped),
            let json: JSON = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSON
            else {
                return XCTFail("Failed mapping Coverage Report JSON")
        }
        
        let c = CoberturaCodeCoverageReport(json: json["results"] as! JSON)
        
        let validChildren = 27
        XCTAssert(c.childReports.count == validChildren, "Report has \(c.childReports.count) children, but should have \(validChildren)")
        
        let validName = "Cobertura Coverage Report"
        XCTAssert(c.name.compare(validName) == ComparisonResult.orderedSame, "Coverage report name is '\(c.name)' but should be \(validName)")
        
        let validCovElements = 5
        XCTAssert(c.coverageElements.count == validCovElements, "Report has \(c.coverageElements.count) coverage elements but should have \(validCovElements)")
        
        let validLineRatio = 0.2
        let actualLineRatio = c.ratio(of: .Lines)
        XCTAssertEqualWithAccuracy(actualLineRatio, validLineRatio, accuracy: 0.05, "Ratio is \(actualLineRatio) but should be \(validLineRatio)")
    }
    
}


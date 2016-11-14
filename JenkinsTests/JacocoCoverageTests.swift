//
//  JacocoCoverageTests.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 11/13/16.
//
//

import Foundation
import XCTest
@testable import Jenkins

class JacocoCoverageTests: XCTestCase {
    
    func testJacocoCodeCoverageDepth2() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "JacocoCoverageReportDepth", ofType: "json") else {
            return XCTFail("Missing Jacoco Coverage Report JSON")
        }
        
        guard
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped),
            let json: JSON = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSON
            else {
                return XCTFail("Failed mapping Coverage Report JSON")
        }
        
        let coverage = JacocoCodeCoverageReport(json: json)
        
        let validBranchRatio = 0.61
        let actualBranchRatio = coverage.ratio(of: JacocoCodeCoverageElementType.BranchCoverage)
        XCTAssertEqualWithAccuracy(actualBranchRatio, validBranchRatio, accuracy: 0.05)
        
        let validClassRatio = 0.72
        let actualClassRatio = coverage.ratio(of: JacocoCodeCoverageElementType.ClassCoverage)
        XCTAssertEqualWithAccuracy(actualClassRatio, validClassRatio, accuracy: 0.05)
        
        let validComplexityRatio = 0.59
        let actualComplexityRatio = coverage.ratio(of: JacocoCodeCoverageElementType.ComplexityCoverage)
        XCTAssertEqualWithAccuracy(actualComplexityRatio, validComplexityRatio, accuracy: 0.05)
        
        let validInstructionRatio = 0.74
        let actualInstructionRatio = coverage.ratio(of: JacocoCodeCoverageElementType.InstructionCoverage)
        XCTAssertEqualWithAccuracy(actualInstructionRatio, validInstructionRatio, accuracy: 0.05)
        
        let validLineRatio = 0.73
        let actualLineRatio = coverage.ratio(of: JacocoCodeCoverageElementType.LineCoverage)
        XCTAssertEqualWithAccuracy(actualLineRatio, validLineRatio, accuracy: 0.05)
        
        let validMethodRatio = 0.69
        let actualMethodRatio = coverage.ratio(of: JacocoCodeCoverageElementType.MethodCoverage)
        XCTAssertEqualWithAccuracy(actualMethodRatio, validMethodRatio, accuracy: 0.05)
    }
}

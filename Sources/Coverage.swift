//
//  Coverage.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 11/13/16.
//
//

import Foundation

public protocol CoverageReport {
    func ratio(of element: CoverageElementType) -> Double
}

/*
 * Coverage Element
 */

public protocol CoverageElementType {}

public protocol CoverageElement {
    var elementType: CoverageElementType { get }
    var covered: Int { get }
    var total: Int { get }
    
    func missed() -> Int
    func ratio() -> Double
}

extension CoverageElement {
    public func missed() -> Int {
        return max(0, (total - covered))
    }
    
    public func ratio() -> Double {
        return fmax(0, (Double(covered) / Double(total)))
    }
}

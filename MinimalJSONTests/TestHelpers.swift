//
//  TestHelpers.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 9/1/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation
import XCTest
@testable import MinimalJSON

// MARK: JSON loading helpers

internal let JSONTestErrorDomain = "com.bencochran.MinimalJSONTests"
internal enum JSONTestErrorCode: Int {
    case UnknownFile = 1
}

private final class SillyClassForBundle: NSObject { }

private func pathForJSONNamed(name: String) -> String? {
    return NSBundle(forClass: SillyClassForBundle.self).pathForResource(name, ofType: "json")
}

private func dataForJSONNamed(name: String) throws -> NSData {
    guard let path = pathForJSONNamed(name) else {
        throw NSError(domain: JSONTestErrorDomain, code: JSONTestErrorCode.UnknownFile.rawValue, userInfo: nil)
    }
    return try NSData(contentsOfFile: path, options: [])
}

internal func loadJSONNamed(name: String) throws -> JSONValue {
    let data = try dataForJSONNamed(name)
    return try JSONValue(parse: data)
}


// MARK: XCTest additions

func assertEqual<T: Equatable>(@autoclosure expression1: () throws -> T?, @autoclosure _ expression2: () throws -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) rethrows {
    let lhs: T? = try expression1()
    let rhs: T? = try expression2()
    XCTAssertEqual(lhs, rhs, message, file: file, line: line)
}

func assertEqual<T: Equatable>(@autoclosure expression1: () throws -> [T], @autoclosure _ expression2: () throws -> [T], _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) rethrows {
    let lhs: [T] = try expression1()
    let rhs: [T] = try expression2()
    XCTAssertEqual(lhs, rhs, message, file: file, line: line)
}


func doFailingErrors(file: String = __FILE__, line: UInt = __LINE__, @noescape _ expression: () throws -> ()) {
    do {
        try expression()
    } catch {
        XCTFail("Caught error: \(error)", file: file, line: line)
    }
}


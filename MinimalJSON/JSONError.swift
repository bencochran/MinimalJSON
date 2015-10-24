//
//  JSONError.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 8/31/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation

public enum JSONErrorType {
    case UnableToParse
    case MissingKey(key: String)
    case OutOfBounds(index: Int)
    case IncompatibleType(typename: String)
}

public struct JSONError: ErrorType {
    public let type: JSONErrorType
    public let json: JSONValue?
    internal let file: String
    internal let line: Int
    
    internal init(_ type: JSONErrorType, json: JSONValue? = nil, file: String = __FILE__, line: Int = __LINE__) {
        self.type = type
        self.json = json
        self.file = file
        self.line = line
    }
}

extension JSONError: CustomDebugStringConvertible {
    public var debugDescription: String {
        let jsonString = "\(json)" ?? "(null)"
        return "JSONError(\(type), json: \(jsonString))"
    }
}

extension JSONErrorType: Equatable { }
public func ==(lhs: JSONErrorType, rhs: JSONErrorType) -> Bool {
    switch (lhs, rhs) {
    case (.UnableToParse, .UnableToParse): return true
    case let (.MissingKey(l), .MissingKey(r)): return l == r
    case let (.OutOfBounds(l), .OutOfBounds(r)): return l == r
    case let (.IncompatibleType(l), .IncompatibleType(r)): return l == r
    default: return false
    }
}

//
//  JSONValue.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 8/31/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation

public struct JSONValue {
    internal var wrapped: Any
    
    /// Initialize a `JSONValue` by parsing the given `NSData`
    public init(parse data: NSData) throws {
        self = try JSONValue(NSJSONSerialization.JSONObjectWithData(data, options: []))
    }
    
    /// Initialize a `JSONValue` by parsing the given string
    public init(parse string: NSString, usingEncoding encoding: UInt = NSUTF8StringEncoding) throws {
        guard let data = string.dataUsingEncoding(encoding) else {
            throw JSONError(.UnableToParse)
        }
        self = try JSONValue(parse: data)
    }
    
    /// Initiazlie a `JSONValue` with the given value. This assumes the value is a
    /// JSON-compatible object (or you won’t be given much benefit by wrapping it in a
    /// `JSONValue`)
    public init(_ any: Any) {
        wrapped = any
    }
}

// Private helpers
extension JSONValue {
    private func asArray() throws -> [JSONValue] {
        guard let objectArray = self.wrapped as? [AnyObject] else {
            throw JSONError(.IncompatibleType(typename: "array"), json: self)
        }
        return objectArray.map({ JSONValue($0) })
    }
    
    private func asDictionary() throws -> [String:JSONValue] {
        guard let objectDictionary = self.wrapped as? [String:AnyObject] else {
            throw JSONError(.IncompatibleType(typename: "dictionary"), json: self)
        }
        return objectDictionary.transform({ JSONValue($0) })
    }
}

// Public traversal and decoding methods
extension JSONValue {
    
    // (If it were supported, this would be: `subscript(key: String) throws -> JSONValue`)
    
    /// Pulls an items out of a JSON dictionary.
    ///
    /// Throws a `JSONError` if the receiver does not wrap a dictionary or if the given key does
    /// not exist in the dictionary.
    public func sub(key: String) throws -> JSONValue {
        guard let value = try self.asDictionary()[key] else {
            throw JSONError(.MissingKey(key: key), json: self)
        }
        return value
    }
    
    /// Attempts to decode the receiver’s wrapped value as type `T`
    ///
    /// Throws a `JSONError` if the receiver does not wrap a value that can be converted into the
    /// desired type.
    public func decode<T: JSONDecodable>() throws -> T {
        return try T.decode(self)
    }

    /// Attempts to decode the receiver’s wrapped value as an array of values of type `T`
    ///
    /// Throws a `JSONError` if the receiver does not wrap a value that can be converted into  an
    /// array of the desired type.
    public func decode<T: JSONDecodable>() throws -> [T] {
        return try self.asArray().map(T.decode)
    }
}

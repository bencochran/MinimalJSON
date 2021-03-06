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
    internal var error: ErrorType? = nil
    
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
    
    internal init(error: ErrorType) {
        self.wrapped = ()
        self.error = error
    }
}

// Private helpers
extension JSONValue {
    private func asArray() throws -> [JSONValue] {
        let objectArray: [AnyObject] = try self.decode()
        return objectArray.map({ JSONValue($0) })
    }
    
    private func asDictionary() throws -> [String:JSONValue] {
        let objectDictionary: [String:AnyObject] = try self.decode()
        return objectDictionary.transform({ JSONValue($0) })
    }
    
    private func throwIfError() throws {
        if let error = self.error {
            throw error
        }
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
        try throwIfError()
        guard let value = try self.asDictionary()[key] else {
            throw JSONError(.MissingKey(key: key), json: self)
        }
        return value
    }
    
    public func sub(var index: Int) throws -> JSONValue {
        try throwIfError()
        let array = try self.asArray()
        if index < 0 {
            let backwardsIndex = array.endIndex.advancedBy(index)
            guard backwardsIndex >= 0 else {
                throw JSONError(.OutOfBounds(index: index), json: self)
            }
            index = backwardsIndex
        }
        guard index < array.endIndex else {
            throw JSONError(.OutOfBounds(index: index), json: self)
        }
        return array[index]
    }
    
    public subscript(key: String) -> JSONValue {
        do {
            return try self.sub(key)
        } catch {
            return JSONValue(error: error)
        }
    }
    
    public subscript(index: Int) -> JSONValue {
        do {
            return try self.sub(index)
        } catch {
            return JSONValue(error: error)
        }
    }
    
    /// Attempts to decode the receiver’s wrapped value as type `T`
    ///
    /// Throws a `JSONError` if the receiver does not wrap a value that can be converted into the
    /// desired type.
    public func decode<T: JSONDecodable>() throws -> T {
        try throwIfError()
        return try T.decode(self)
    }

    /// Attempts to decode the receiver’s wrapped value as an array of values of type `T`
    ///
    /// Throws a `JSONError` if the receiver does not wrap a value that can be converted into  an
    /// array of the desired type.
    public func decode<T: JSONDecodable>() throws -> [T] {
        try throwIfError()
        return try self.asArray().map(T.decode)
    }

    public func decode() throws -> AnyObject {
        try throwIfError()
        guard let object = self.wrapped as? AnyObject else {
            throw JSONError(.IncompatibleType(typename: "AnyObject"), json: self)
        }
        return object
    }
    
    public func decode() throws -> [AnyObject] {
        try throwIfError()
        guard let objectArray = self.wrapped as? [AnyObject] else {
            throw JSONError(.IncompatibleType(typename: "array"), json: self)
        }
        return objectArray
    }
    
    public func decode() throws -> [String:AnyObject] {
        try throwIfError()
        guard let objectDictionary = self.wrapped as? [String:AnyObject] else {
            throw JSONError(.IncompatibleType(typename: "dictionary"), json: self)
        }
        return objectDictionary
    }
}


extension JSONValue : CollectionType {
    public var startIndex: Int {
        return 0
    }
    /// The `endIndex` of the collection that is wrapped by this JSONValue. If
    /// the wrapped value is not a collection, this return 1 so that in most
    /// common cases you will try to subscript the JSONValue, resulting in an
    /// error. (Since `endIndex` itself cannot throw an error)
    public var endIndex: Int {
        do {
            return try asArray().endIndex
        } catch {
            return 1
        }
    }
}

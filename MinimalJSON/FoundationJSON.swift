//
//  FoundationJSON.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 8/31/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation

extension JSONDecodable {
    /// Decode json types that come straight from `NSJSONSerialization`
    public static func decode(json: JSONValue) throws -> Self {
        /// Try to cast types, NSJSONSerialization-native types will succeed, others will throw
        guard let decoded = json.object as? Self else {
            throw JSONError(.IncompatibleType(typename: "\(Self.self)"), json: json)
        }
        return decoded
    }
}

// Mark the types that are handled by the above protocol extension, but let the extension do
// the work
extension String: JSONDecodable { }
extension Int: JSONDecodable { }
extension Double: JSONDecodable { }
extension Bool: JSONDecodable { }

extension NSURL: JSONDecodable {
    /// Decodes a json string as an NSURL
    public static func decode(json: JSONValue) throws -> Self {
        guard let URL = try self.init(string: json.decode()) else {
            throw JSONError(.IncompatibleType(typename: "NSURL"), json: json)
        }
        return URL
    }
}

extension NSDate: JSONDecodable {
    /// Decodes a json string into an `NSDate`, assuming the string is of the
    /// ISO 8601 format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    public static func decode(json: JSONValue) throws -> Self {
        // TODO: Use something faster than creating an NSDateFormatter each time
        let dateFormatter = NSDateFormatter()
        // TODO: Handle more than just this specific ISO 8601 format
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = try dateFormatter.dateFromString(json.decode()) else {
            throw JSONError(.IncompatibleType(typename: "NSDate"), json: json)
        }
        // Use this to get around NSDate not being equal to Self… silly Objective-C classes
        return self.init(timeInterval: 0, sinceDate: date)
    }
}

extension NSTimeZone: JSONDecodable {
    /// Decodes a json string into an `NSTimeZone`, assuming the string is one of the timezone
    /// names present in `NSTimeZone.knownTimeZoneNames()`
    public static func decode(json: JSONValue) throws -> Self {
        // TODO: Parse other timezone formats? (like offsets, etc)
        guard let timeZone = try self.init(name: json.decode()) else {
            throw JSONError(.IncompatibleType(typename: "NSTimeZone"), json: json)
        }
        return timeZone
    }
}


//
//  JSONDecodable.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 8/31/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation

public protocol JSONDecodable {
    static func decode(json: JSONValue) throws -> Self
}

public protocol JSONInitializable: JSONDecodable {
    init(json: JSONValue) throws
}

extension JSONInitializable {
    /// Implement `JSONDecodable.decode()` for `JSONInitializable` types
    public static func decode(json: JSONValue) throws -> Self {
        return try Self(json: json)
    }
}

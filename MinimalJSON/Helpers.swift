//
//  Helpers.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 8/31/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation

extension Dictionary {
    /// Returns a new dictionary by transforming each value in the receiver by applying
    /// the given `transform`. (Leaves the keys untouched)
    @warn_unused_result
    internal func transform<NewValue>(@noescape transform: (Value) -> NewValue) -> Dictionary<Key, NewValue> {
        var newDictionary: [Key: NewValue] = [:]
        for (key, value) in self {
            newDictionary[key] = transform(value)
        }
        return newDictionary
    }
}


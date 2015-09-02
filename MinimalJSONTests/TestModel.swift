//
//  TestModel.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 9/1/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation
import CoreLocation
@testable import MinimalJSON

internal struct Person {
    internal let id: Int
    internal let name: String
    internal let website: NSURL?
    
    internal init(id: Int, name: String, website: NSURL? = nil) {
        self.id = id
        self.name = name
        self.website = website
    }
}

extension Person: JSONInitializable {
    internal init(json: JSONValue) throws {
        self.id = try json["id"].decode()
        self.name = try json["name"].decode()
        self.website = try? json["website"].decode()
    }
}

extension Person: Equatable { }
internal func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.website == rhs.website
}

extension CLLocationCoordinate2D: Equatable { }
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}



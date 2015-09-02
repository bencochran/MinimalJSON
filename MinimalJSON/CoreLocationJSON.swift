//
//  CoreLocationJSON.swift
//  MinimalJSON
//
//  Created by Ben Cochran on 8/31/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: JSONInitializable {
    /// Initialize a `CLLocationCoordinate2D` with a json dictionary of the format:
    ///   {
    ///     "latitude": 37.7241452,
    ///     "longitude": -122.4409553
    ///   }
    public init(json: JSONValue) throws {
        self.latitude = try json["latitude"].decode()
        self.longitude = try json["longitude"].decode()
    }
}

//
//  MinimalJSONTests.swift
//  MinimalJSONTests
//
//  Created by Ben Cochran on 8/31/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import XCTest
import CoreLocation
@testable import MinimalJSON

class MinimalJSONTests: XCTestCase {
    func testBasicTypes() {
        doFailingErrors {
            let json = try loadJSONNamed("types")
            try assertEqual(json["integer"].decode() as Int, 42)
            try assertEqual(json["double"].decode() as Double, 3.14)
            try assertEqual(json["string"].decode() as String, "hello, world")
            try assertEqual(json["boolean"].decode() as Bool, false)
            try assertEqual(json["array_string"].decode() as [String], ["hello", "world"])
            try assertEqual(json["array_int"].decode() as [Int], [1, 2, 3, 4, 5])
            try assertEqual(json["array_double"].decode() as [Double], [1.2, 3.4, 5.6])
            try assertEqual(json["array_empty"].decode() as [String], [])
            try assertEqual(json["array_empty"].decode() as [Int], [])
            try assertEqual(json["array_empty"].decode() as [NSURL], [])
            try assertEqual(json["dictionary"]["integer"].decode() as Int, 64)
            try assertEqual(json["dictionary"]["string"].decode() as String, "apples")
        }
    }
    
    func testFoundationTypes() {
        let controlURL = NSURL(string: "https://developer.apple.com/swift/")!
        let controlDate = NSDate(timeIntervalSince1970: 1441069323)
        let controlTimeZone = NSTimeZone(name: "America/Los_Angeles")!
        
        doFailingErrors {
            let json = try loadJSONNamed("foundation_types")
            try assertEqual(json["url"].decode() as NSURL, controlURL)
            try assertEqual(json["date"].decode() as NSDate, controlDate)
            try assertEqual(json["timezone"].decode() as NSTimeZone, controlTimeZone)
        }
    }
    
    func testCoordinate() {
        doFailingErrors {
            let json = try loadJSONNamed("coordinate")
            let controlCoordinate = CLLocationCoordinate2D(latitude: 37.7241452, longitude: -122.4409553)
            try assertEqual(json.decode() as CLLocationCoordinate2D, controlCoordinate)
        }
    }
    
    func testCustomType() {
        let controlPeople = [
            Person(id: 1, name: "Ben", website: NSURL(string: "http://bencochran.com")!),
            Person(id: 3, name: "Chris"),
            Person(id: 4, name: "Kat")
        ]
        
        doFailingErrors {
            let json = try loadJSONNamed("array_person")
            try assertEqual(json.decode() as [Person], controlPeople)
        }
    }
    
    func testArrayAccess() {
        doFailingErrors {
            let json = try loadJSONNamed("array_person")
            try assertEqual(json[0]["name"].decode() as String, "Ben")
            try assertEqual(json[1]["name"].decode() as String, "Chris")
            try assertEqual(json[-2]["name"].decode() as String, "Chris")
            try assertEqual(json[-1]["id"].decode() as Int, 4)
        }
    }
}

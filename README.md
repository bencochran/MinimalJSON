# MinimalJSON

There are [plenty of](https://github.com/SwiftyJSON/SwiftyJSON) [great](https://github.com/thoughtbot/Argo) [Swift](https://github.com/Hearst-DD/ObjectMapper) [JSON](https://github.com/delba/JASON) [libraries](https://github.com/owensd/json-swift). Seriously, too many of them. So here’s another.

This primarily set out to fulfill my own desire to have my JSON parsing happen with as plain a syntax as possible and Swift 2 makes that easy.

**MinimalJSON requires Swift 2.0 beta 6.**

## Overview

Types can implement `JSONInitializable` (best for value types) or `JSONDecodable` (better for classes because initializers from protocols is painful).

All `JSONValue` “subscripting”<sup><a href="#sub">1</a></sup> and decoding methods throw, so errors can naturally flow to the top of your parser (or use `try?` to ignore acceptable errors such as optional keys).

## Example

```swift
struct Person {
    let id: Int
    let name: String
    let birthday: NSDate?
    let website: NSURL?
}

extension Person: JSONInitializable {
    init(json: JSONValue) throws {
        self.id = try json.sub("id").decode()
        self.name = try json.sub("name").decode()
        self.birthday = try? json.sub("birthday").decode()
        self.website = try? json.sub("website").decode()
    }
}

let jsonString = "{ \"id\" : 1, \"name\" : \"Ben\"}"

do {
    let json = JSONValue(parse: jsonString)
    let person: Person = try json.decode()
    print(person)
} catch {
    print("Error decoding: \(error)")
}
```


--

<a name="sub"><sup>1.</sup></a> `JSONValue` would implement `subscript(key: String) throws -> JSONValue` if `subscript` could throw. But alas, it cannot as of Swift 2.0 Beta 6.

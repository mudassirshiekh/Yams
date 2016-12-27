//
//  Tag.swift
//  Yams
//
//  Created by Norio Nomura on 12/15/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

#if SWIFT_PACKAGE
    import CYaml
#endif
import Foundation

public final class Tag {
    public struct Name: RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    // internal
    let constructor: Constructor
    var name: Name?

    init(_ string: String?,
         _ resolver: Resolver,
         _ constructor: Constructor) {
        self.resolver = resolver
        self.constructor = constructor
        if let string = string, !string.isEmpty && string != "!" {
            name = Name(rawValue: string)
        } else {
            name = nil
        }
    }

    init(_ name: Name,
         _ resolver: Resolver,
         _ constructor: Constructor) {
        self.resolver = resolver
        self.constructor = constructor
        self.name = name
    }

    func resolved(with node: Node) -> Tag {
        if name == nil {
            name = resolver.resolveTag(of: node)
        }
        return self
    }

    static var implicit: Tag {
        return Tag(nil, .default, .default)
    }

    // fileprivate
    fileprivate let resolver: Resolver
}

extension Tag: Hashable {
    public var hashValue: Int {
        return name?.hashValue ?? 1
    }

    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        switch (lhs.name, rhs.name) {
        case let (lhs?, rhs?): return lhs == rhs
        case (.none, _): fallthrough
        case (_, .none): fatalError("unreachable")
        default: return false
        }
    }
}

extension Tag.Name: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    public init(unicodeScalarLiteral value: String) {
        self.rawValue = value
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.rawValue = value
    }
}

extension Tag.Name: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }

    public static func == (lhs: Tag.Name, rhs: Tag.Name) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

// http://www.yaml.org/spec/1.2/spec.html#Schema
extension Tag.Name {
    // Failsafe Schema
    /// "tag:yaml.org,2002:str" <http://yaml.org/type/str.html>
    public static let str: Tag.Name = "tag:yaml.org,2002:str"
    /// "tag:yaml.org,2002:seq" <http://yaml.org/type/seq.html>
    public static let seq: Tag.Name  = "tag:yaml.org,2002:seq"
    /// "tag:yaml.org,2002:map" <http://yaml.org/type/map.html>
    public static let map: Tag.Name  = "tag:yaml.org,2002:map"
    // JSON Schema
    /// "tag:yaml.org,2002:bool" <http://yaml.org/type/bool.html>
    public static let bool: Tag.Name  = "tag:yaml.org,2002:bool"
    /// "tag:yaml.org,2002:float" <http://yaml.org/type/float.html>
    public static let float: Tag.Name  =  "tag:yaml.org,2002:float"
    /// "tag:yaml.org,2002:null" <http://yaml.org/type/null.html>
    public static let null: Tag.Name  = "tag:yaml.org,2002:null"
    /// "tag:yaml.org,2002:int" <http://yaml.org/type/int.html>
    public static let int: Tag.Name  = "tag:yaml.org,2002:int"
    // http://yaml.org/type/index.html
    /// "tag:yaml.org,2002:binary" <http://yaml.org/type/binary.html>
    public static let binary: Tag.Name  = "tag:yaml.org,2002:binary"
    /// "tag:yaml.org,2002:merge" <http://yaml.org/type/merge.html>
    public static let merge: Tag.Name  = "tag:yaml.org,2002:merge"
    /// "tag:yaml.org,2002:omap" <http://yaml.org/type/omap.html>
    public static let omap: Tag.Name  = "tag:yaml.org,2002:omap"
    /// "tag:yaml.org,2002:pairs" <http://yaml.org/type/pairs.html>
    public static let pairs: Tag.Name  = "tag:yaml.org,2002:pairs"
    /// "tag:yaml.org,2002:set". <http://yaml.org/type/set.html>
    public static let set: Tag.Name  = "tag:yaml.org,2002:set"
    /// "tag:yaml.org,2002:timestamp" <http://yaml.org/type/timestamp.html>
    public static let timestamp: Tag.Name  = "tag:yaml.org,2002:timestamp"
    /// "tag:yaml.org,2002:value" <http://yaml.org/type/value.html>
    public static let value: Tag.Name  = "tag:yaml.org,2002:value"
    /// "tag:yaml.org,2002:yaml" <http://yaml.org/type/yaml.html> We don't support this.
    public static let yaml: Tag.Name  = "tag:yaml.org,2002:yaml"
}

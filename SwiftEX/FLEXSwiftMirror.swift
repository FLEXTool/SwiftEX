//
//  FLEXSwiftMirror.swift
//  SwiftEX
//
//  Created by Tanner on 1/27/21.
//

import UIKit
import Runtime

@objc
public class FLEXSwiftMirror: NSObject {
    var object: AnyObject
//    let mirror: Mirror
    let mirror: TypeInfo
    let isClass: Bool = false
    
    var properties: [PropertyInfo] { self.mirror.properties }
    
    public init(reflecting object: AnyObject) throws {
        self.object = object
//        self.mirror = Mirror(reflecting: object)
        self.mirror = try typeInfo(of: object_getClass(object)!)
//        self.isClass = 
        
        super.init()
    }
    
    public func getValue(forKey key: String) throws -> Any? {
        // Intentionally crash if property does not exist
        let prop = try! self.mirror.property(named: key)
        // Throw error if getting property fails
        return try prop.get(from: self.object)
    }
    
    public func set(value: Any, forKey key: String) throws {
        // Intentionally crash if property does not exist
        let prop = try! self.mirror.property(named: key)
        // Throw error if setting property fails
        try prop.set(value: value, on: &self.object)
    }
}

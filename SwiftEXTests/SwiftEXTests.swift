//
//  SwiftEXTests.swift
//  SwiftEXTests
//
//  Created by Tanner on 1/27/21.
//

import XCTest
@testable import SwiftEX
@testable import Runtime

class SwiftEXTests: XCTestCase {
    let count = 0
    let uuid = "abcdefg" 
    let pi = 3.14
    let list = [1, 2, 3]
    let yes = true
    let no = false
    var object = UIColor.white
    
    func testAssumptions() {
        let cls: AnyClass = SwiftEXTests.self
        let stringyClass: AnyClass = NSClassFromString("SwiftEXTests.SwiftEXTests")!
        
        XCTAssert(type(of: self) === cls)
        XCTAssert(stringyClass === cls)
        
        self.expects(instance: self)
        self.expects(class: cls)
        self.expects(class: stringyClass)
        self.expects(class: NSObject.self)
        self.expects(class: NSClassFromString("NSString")!)
    }
    
    func testMirror() {
        let swiftMirror = Mirror(reflecting: self)
        let pcount = swiftMirror.children.count
        
        let mirror = try! FLEXSwiftMirror(reflecting: self)
        XCTAssertEqual(mirror.properties.count, pcount)
        
        let obj = try! mirror.getValue(forKey: "object")!
        
        XCTAssert(obj as AnyObject === self.object)
    }
    
    class Foo {
        internal init(id: Int = 5, name: String = "bob", color: UIColor = UIColor.red) {
            self.id = id
            self.name = name
            self.color = color
        }
        
        var id = 5
        var name = "bob"
        var color = UIColor.red
    }
    
    func testMirrorStruct() {
        let f = Foo()
        let mirror = try! typeInfo(of: type(of: f))
        let prop = try! mirror.property(named: "color")
        let id = try! prop.get(from: f)
        XCTAssert(id as AnyObject === f.color)
    }
}

// MARK: Expectations
extension SwiftEXTests {
    func expects(instance instanceAsAny: Any) {
        XCTAssertNotNil(instanceAsAny as AnyObject)
        XCTAssertNil(instanceAsAny as? AnyClass)
    }
    
    func expects(class classAsAny: Any) {
        XCTAssertNotNil(classAsAny as? AnyClass)
        XCTAssertNotNil((classAsAny as AnyObject) as? AnyClass)
        XCTAssertFalse(class_isMetaClass(classAsAny as? AnyClass))
    }
    
    func expects(metaclass metaAsAny: Any) {
        XCTAssertNotNil(metaAsAny as? AnyClass)
        XCTAssertNotNil((metaAsAny as AnyObject) as? AnyClass)
        XCTAssert(class_isMetaClass(metaAsAny as? AnyClass))
    }
}

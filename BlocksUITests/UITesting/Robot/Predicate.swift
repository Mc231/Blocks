//
//  Predicate.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 09.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import XCTest

/// https://github.com/jhandguy/SwiftKotlination/blob/master/ios/SwiftKotlination/SwiftKotlinationUITests/Sources/Robot/Predicate.swift
public enum Predicate {
    case contains(String), doesNotContain(String)
    case exists, doesNotExist
    case has(Int, XCUIElement.ElementType), doesNotHave(Int, XCUIElement.ElementType)
    case isHittable, isNotHittable
    
    var format: String {
        switch self {
        case .contains(let label):
            return "label == \(label)"
        case .doesNotContain(let label):
            return "label != \(label)"
        case .exists:
            return "exists == true"
        case .doesNotExist:
            return "exists == false"
        case .has(let count, let element):
            return "\(element.name)s.count == \(count)"
        case .doesNotHave(let count, let element):
            return "\(element.name)s.count != \(count)"
        case .isHittable:
            return "isHittable == true"
        case .isNotHittable:
            return "isHittable == false"
        }
    }
}

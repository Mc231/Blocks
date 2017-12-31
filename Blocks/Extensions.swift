//
//  Extensions.swift
//  Blocks
//
//  Created by Volodya on 3/21/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

extension Int16 {

    static func randomNum(maxValue: Int) -> Int16 {
        let uintMaxValue = UInt32(maxValue)
        return Int16(arc4random_uniform(uintMaxValue))
    }
}

extension UIColor {

    struct CellBackgrounds {
        static let empty = UIColor(red: 237.0 / 255.0, green: 234.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
        static let placed = UIColor(red: 253.0 / 255, green: 148.0 / 255, blue: 56.0 / 255, alpha: 1.0)
        static let selected = UIColor(red: 140.0 / 255, green: 155.0 / 255, blue: 42.0 / 255, alpha: 1.0)
    }
}

extension UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UIDevice {
	
	var iPhoneX: Bool {
		return UIScreen.main.nativeBounds.height == 2436
	}

	var iPhone: Bool {
		return UIDevice.current.userInterfaceIdiom == .phone
	}

	enum ScreenType: String {
		case iPhone4 = "iPhone 4 or iPhone 4S"
		case iPhones5 = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
		case iPhones6 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
		case iPhones6Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
		case iPhoneX = "iPhone X"
		case unknown
	}

	var screenType: ScreenType {
		switch UIScreen.main.nativeBounds.height {
		case 960:
			return .iPhone4
		case 1136:
			return .iPhones5
		case 1334:
			return .iPhones6
		case 1920, 2208:
			return .iPhones6Plus
		case 2436:
			return .iPhoneX
		default:
			return .unknown
		}
	}
}

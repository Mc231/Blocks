//
//  Array+Additions.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 02.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
	
	/**
	Pick random elements from array
	- parameter elementsCount: Number of elements to pick
	- Returns: Empty array if count grater that number of elements or random elements
	*/
	func randomElements(elementsCount: Int) -> [Element] {
		return isEmpty || elementsCount > count ? [] : Array(shuffled()[0..<elementsCount])
	}
}

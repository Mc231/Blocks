//
//  Array+Teramonio.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 02.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

extension Array where Element == Tetramonio {
	
	/// Returns tetramnio by its id type
	subscript(id: Int16) -> Element? {
		return self.first(where: {$0.id.rawValue == id})
	}
	
	/// Returns tetramnio by it id types
	subscript(ids: [Int16]) -> [Element] {
		return ids.reduce(into: [Element]()) { (result, id) in
			if let element = self[id] {
				result.append(element)
			}
		}
	}
	
	/**
	Replace teramonio element for specific generation type
	- parameter generationType: Represents generation type index
	- parameter possibleTetramonios: All possible teramonios to generate
	- Returns: Replaced elements
	*/
	mutating func replaceElement(for generationType: GenerationType,
						  possibleTetramonios: [Tetramonio]) -> [Element] {
		if isEmpty {
			print("Array must not be empty")
			return self
		}
		var tetramonios = possibleTetramonios
		tetramonios.removeAll(where: {$0 == first || $0 == last})
		let random = tetramonios.randomElement()
		self[generationType.rawValue] = random!
		return self
	}
}

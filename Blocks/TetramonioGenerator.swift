//
//  GameFlowManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetramonioGeneratable {
	/// Represents tetramonios that user can place on the field
    var currentTetramonios: [Tetramonio] {get set}
    func generateTetramonios(of generationType: GenerationType) -> [Tetramonio]
    func getTetramoniosFromIds(_ ids: [Int16]) -> [Tetramonio]
}

/// Represents possible generation type int value represent index in array
enum GenerationType: Int {
	case gameStart = -1
	case firtTetramonio = 0
	case secondTetramonio = 1
}

/// Generate teramonios
class TetramonioGenerator: TetramonioGeneratable {
	
	// MARK: - Constatns
	
	private static let randomElementsCount = 2
	
    // MARK: - Properties

    private let allTetramonios: [Tetramonio]
	var currentTetramonios: [Tetramonio] = []

    // MARK: - Inizialization

    init(loader: TetramonioLoadable) throws {
		self.allTetramonios = try loader.load()
    }

    func generateTetramonios(of generationType: GenerationType) -> [Tetramonio] {
        var result = [Tetramonio]()
        if generationType == .gameStart {
			result = allTetramonios.randomElements(elementsCount: Self.randomElementsCount)
        }else{
			result = currentTetramonios.replaceElement(for: generationType,
													   possibleTetramonios: allTetramonios)
        }
        currentTetramonios = result
        return result
    }

    func getTetramoniosFromIds(_ indexes: [Int16]) -> [Tetramonio] {
		return allTetramonios[indexes]
    }
}

//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetramonioProtocol {
    func generateTetramonios(_ generationType: GenerationType) -> [Tetramonio]
    func getTetramoniosFrom(_ indexes: [Int16]?) -> [Tetramonio]
    var currentTetramonios: [Tetramonio] {get set}
}

enum GenerationType: Int {
    case gameStart = -1
    case firtTetramonio = 0
    case secondTetramonio = 1
}

class TetramonioManager: TetramonioProtocol {

    // MARK: - Properties

    private let tetramonios: [Tetramonio]
    private let tetramonioDataProvider: TetremonioDataProvider
	internal var currentTetramonios = [Tetramonio]()

    // MARK: - Inizialization

    init(tetramonioDataProvider: TetremonioDataProvider) {
        self.tetramonioDataProvider = tetramonioDataProvider
        self.tetramonios = tetramonioDataProvider.tetramonios
    }

    func generateTetramonios(_ generationType: GenerationType = .gameStart) -> [Tetramonio] {
        var result = [Tetramonio]()
        let numOfTetramonios = tetramonios.count
        if generationType == .gameStart {
            let firstTetramonioIndex = Int16.randomNum(maxValue: numOfTetramonios)
            let secondTetramonioIndex = Int16.randomNum(maxValue: numOfTetramonios)

            if firstTetramonioIndex != secondTetramonioIndex {
                result.append(tetramonios[Int(firstTetramonioIndex)])
                result.append(tetramonios[Int(secondTetramonioIndex)])
            } else {
                return generateTetramonios()
            }
        } else {
           guard let firstTetrmonio = currentTetramonios.first,
                 let lastTetramonio = currentTetramonios.last else {
                fatalError("Tetramonios could not be nil")
            }

             var randomTetamonio = Int16.randomNum(maxValue: numOfTetramonios)

            if generationType == .firtTetramonio {

                while firstTetrmonio.type.rawValue == randomTetamonio
					|| randomTetamonio == lastTetramonio.type.rawValue {
                    randomTetamonio = Int16.randomNum(maxValue: numOfTetramonios)
                }
                  result.append(tetramonios[Int(randomTetamonio)])
                  result.append(lastTetramonio)
            } else {
                while lastTetramonio.type.rawValue == randomTetamonio
					|| randomTetamonio == firstTetrmonio.type.rawValue {
                    randomTetamonio = Int16.randomNum(maxValue: numOfTetramonios)
                }
                    result.append(firstTetrmonio)
                    result.append(tetramonios[Int(randomTetamonio)])
            }
        }

        currentTetramonios = result

        return result
    }

    func getTetramoniosFrom(_ indexes: [Int16]?) -> [Tetramonio] {

        guard let indexes = indexes else {
            fatalError("Indexes can not be nil")
        }

		return indexes.reduce(into: [Tetramonio](), { (result, value) in
			guard let tetramonioIndex = tetramonios.firstIndex(where: {$0.type.rawValue == value}) else {
				fatalError("Impossible tetramonio")
			}
			let tetamonio = tetramonios[tetramonioIndex]
			result.append(tetamonio)
		})
    }
}

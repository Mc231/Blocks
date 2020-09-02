//
//  GameFlowManager.swift
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

class TetramonioHelper: TetramonioProtocol {

    // MARK: - Properties

    private let tetramonios: [Tetramonio]
    private let tetramonioDataProvider: TetremonioLoader
	internal var currentTetramonios = [Tetramonio]()

    // MARK: - Inizialization

    init(tetramonioDataProvider: TetremonioLoader) {
        self.tetramonioDataProvider = tetramonioDataProvider
		#warning("Fix this")
		self.tetramonios = try! tetramonioDataProvider.load()
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

                while firstTetrmonio.id.rawValue == randomTetamonio
					|| randomTetamonio == lastTetramonio.id.rawValue {
                    randomTetamonio = Int16.randomNum(maxValue: numOfTetramonios)
                }
                  result.append(tetramonios[Int(randomTetamonio)])
                  result.append(lastTetramonio)
            } else {
                while lastTetramonio.id.rawValue == randomTetamonio
					|| randomTetamonio == firstTetrmonio.id.rawValue {
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
			guard let tetramonioIndex = tetramonios.firstIndex(where: {$0.id.rawValue == value}) else {
				fatalError("Impossible tetramonio")
			}
			let tetamonio = tetramonios[tetramonioIndex]
			result.append(tetamonio)
		})
    }
}

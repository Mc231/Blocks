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
    func getTetramonios(_ currentTetramonios: ([Tetramonio]) -> ())
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
    private var currentTetramonios = [Tetramonio]()
    
    init(tetramonioDataProvider: TetremonioDataProvider) {
        self.tetramonioDataProvider = tetramonioDataProvider
        self.tetramonios = tetramonioDataProvider.getTetramonios()
    }
    
    func generateTetramonios(_ generationType: GenerationType = .gameStart) -> [Tetramonio] {
        var result = [Tetramonio]()
        let numOfTetramonios = tetramonios.count
        if generationType == .gameStart {
            let firstTetramonioIndex = Int.randomNum(maxValue: numOfTetramonios)
            let secondTetramonioIndex = Int.randomNum(maxValue: numOfTetramonios)
            
            if firstTetramonioIndex != secondTetramonioIndex {
                result.append(tetramonios[firstTetramonioIndex])
                result.append(tetramonios[secondTetramonioIndex])
            }else{
                return generateTetramonios()
            }
        }else{
           guard let firstTetrmonio = currentTetramonios.first,
                 let lastTetramonio = currentTetramonios.last else{
                fatalError("Tetramonios could not be nil")
            }
            
             var randomTetamonio = Int.randomNum(maxValue: numOfTetramonios)
            // WArning fux this
            if generationType == .firtTetramonio {
                
                while firstTetrmonio.id.rawValue == randomTetamonio || randomTetamonio == lastTetramonio.id.rawValue {
                    randomTetamonio = Int.randomNum(maxValue: numOfTetramonios)
                }
                  result.append(tetramonios[randomTetamonio])
                  result.append(lastTetramonio)
            }else{
                while lastTetramonio.id.rawValue == randomTetamonio || randomTetamonio == firstTetrmonio.id.rawValue {
                    randomTetamonio = Int.randomNum(maxValue: numOfTetramonios)
                }
                    result.append(firstTetrmonio)
                    result.append(tetramonios[randomTetamonio])
            }
        }
        
        currentTetramonios = result
        
        return result
    }
    
    func getTetramonios(_ currentTetramonios: ([Tetramonio]) -> ()) {
        currentTetramonios(tetramonios)
    }
}

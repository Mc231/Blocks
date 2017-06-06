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
    func getTetramoniosFrom(indexes: [Int16]?) -> [Tetramonio]
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
    var currentTetramonios = [Tetramonio]()
    
    init(tetramonioDataProvider: TetremonioDataProvider) {
        self.tetramonioDataProvider = tetramonioDataProvider
        self.tetramonios = tetramonioDataProvider.getTetramonios()
    }
    
    func generateTetramonios(_ generationType: GenerationType = .gameStart) -> [Tetramonio] {
        var result = [Tetramonio]()
        let numOfTetramonios = tetramonios.count
        if generationType == .gameStart {
            let firstTetramonioIndex = Int16.randomNum(maxValue: numOfTetramonios)
            let secondTetramonioIndex = Int16.randomNum(maxValue: numOfTetramonios)
            
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
            
            // TODO: - fix garbage with int 16
             var randomTetamonio = Int16(Int16.randomNum(maxValue: numOfTetramonios))
            // WArning fux this
            if generationType == .firtTetramonio {
                
                while firstTetrmonio.id.rawValue == randomTetamonio || randomTetamonio == lastTetramonio.id.rawValue {
                    randomTetamonio = Int16(Int16.randomNum(maxValue: numOfTetramonios))
                }
                  result.append(tetramonios[Int(randomTetamonio)])
                  result.append(lastTetramonio)
            }else{
                while lastTetramonio.id.rawValue == randomTetamonio || randomTetamonio == firstTetrmonio.id.rawValue {
                    randomTetamonio = Int16(Int16.randomNum(maxValue: numOfTetramonios))
                }
                    result.append(firstTetrmonio)
                    result.append(tetramonios[Int(randomTetamonio)])
            }
        }
        
        currentTetramonios = result
        
        return result
    }
    
    func getTetramoniosFrom(indexes: [Int16]?) -> [Tetramonio] {
        var result = [Tetramonio]()
        guard let indexes = indexes else {
            fatalError("Indexes can not be nil")
        }
        for index in indexes {
            guard let tetramonioIndex = tetramonios.index(where: {$0.id.rawValue == index}) else {
                fatalError("Impossible tetramonio")
            }
            let tetamonio = tetramonios[tetramonioIndex]
            result.append(tetamonio)
        }
        return result
    }
}

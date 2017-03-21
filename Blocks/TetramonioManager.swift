//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetramonioProtocol {
    func generateTetramonios(_ updateIndex: Int) -> [Tetramonio]
}

class TetramonioManager: TetramonioProtocol {
    
    private let tetramonios: [Tetramonio]
    private var currentTetramonios = [Tetramonio]()
    
    init() {
        self.tetramonios = TetramonioDataProvider.sharedProvider.parseTetramonios()
    }
    
    func generateTetramonios(_ updateIndex: Int = -1) -> [Tetramonio] {
        var result = [Tetramonio]()
        
        if updateIndex == -1 {
            let firstTetramonioIndex = generateRandomIndex()
            let secondTetramonioIndex = generateRandomIndex()
            
            if firstTetramonioIndex != secondTetramonioIndex {
                result.append(tetramonios[firstTetramonioIndex])
                result.append(tetramonios[secondTetramonioIndex])
            }else{
                return generateTetramonios()
            }
        }else{
            let firstTetrmonio = currentTetramonios.first
            let lastTetramonio = currentTetramonios.last
            if updateIndex == 0 {
                let randomTetamonio = generateRandomIndex()
                if firstTetrmonio?.id.rawValue == randomTetamonio {
                    generateTetramonios(0)
                }else{
                  result.append(tetramonios[randomTetamonio])
                  result.append(lastTetramonio!)
                }
            }else{
                let randomTetamonio = generateRandomIndex()
                if lastTetramonio?.id.rawValue == randomTetamonio {
                    generateTetramonios(1)
                }else{
                    result.append(firstTetrmonio)
                    result.append(tetramonios[randomTetamonio])
                }
            }
        }
        
        currentTetramonios = result
        
        return result
    }
    
    func updateTetramonios(_ oldTetramonios: [Tetramonio], newTetramonios: [Tetramonio]) {
        
    }
    
    func getTetramonios(_ currentTetramonios: ([Tetramonio]) -> ()) {
        currentTetramonios(tetramonios)
    }
    
    // MARK: - Private methods
    
    private func generateRandomIndex() -> Int {
        return Int(arc4random_uniform(18))
    }
}

//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetramonioProtocol {
    func generateTetramonios() -> [Tetramonio]
    func updateTetramonios(_ oldTetramonios: [Tetramonio], newTetramonios: [Tetramonio])
    func getTetramonios(_ currentTetramonios: ([Tetramonio]) -> Void)
}

class TetramonioManager: TetramonioProtocol {
    
    let tetramonios: [Tetramonio]
    
    init() {
        self.tetramonios = TetramonioDataProvider.sharedProvider.parseTetramonios()
    }
    
    func generateTetramonios() -> [Tetramonio] {
        var result = [Tetramonio]()
        
        let firstTetramonioIndex =  Int(arc4random_uniform(18))
        let secondTetramonioIndex = Int(arc4random_uniform(18))
        
        if firstTetramonioIndex != secondTetramonioIndex {
            result.append(tetramonios[firstTetramonioIndex])
            result.append(tetramonios[secondTetramonioIndex])
        }else{
            return generateTetramonios()
        }
        
        return result
    }
    
    func updateTetramonios(_ oldTetramonios: [Tetramonio], newTetramonios: [Tetramonio]) {
        
    }
    
    func getTetramonios(_ currentTetramonios: ([Tetramonio]) -> ()) {
        currentTetramonios(tetramonios)
    }
}

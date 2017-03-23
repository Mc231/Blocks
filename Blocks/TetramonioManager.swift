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
    
    private let tetramonios: [Tetramonio]
    private var currentTetramonios = [Tetramonio]()
    
    init() {
        self.tetramonios = TetramonioDataProvider.sharedProvider.parseTetramonios()
    }
    
    func generateTetramonios(_ generationType: GenerationType = .gameStart) -> [Tetramonio] {
        var result = [Tetramonio]()
        
        if generationType == .gameStart {
            let firstTetramonioIndex = Int.randomNum
            let secondTetramonioIndex = Int.randomNum
            
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
            
             let randomTetamonio = Int.randomNum
            
            if generationType == .firtTetramonio {
                if firstTetrmonio.id.rawValue == randomTetamonio && lastTetramonio.id.rawValue != firstTetrmonio.id.rawValue {
                    _ = generateTetramonios(.firtTetramonio)
                }else{
                  result.append(tetramonios[randomTetamonio])
                  result.append(lastTetramonio)
                }
            }else{
                if lastTetramonio.id.rawValue == randomTetamonio  && lastTetramonio.id.rawValue != firstTetrmonio.id.rawValue {
                    _ = generateTetramonios(.secondTetramonio)
                }else{
                    result.append(firstTetrmonio)
                    result.append(tetramonios[randomTetamonio])
                }
            }
        }
        
        currentTetramonios = result
        
        return result
    }
    
    func getTetramonios(_ currentTetramonios: ([Tetramonio]) -> ()) {
        currentTetramonios(tetramonios)
    }
}

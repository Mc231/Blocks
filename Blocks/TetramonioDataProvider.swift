//
//  TetramonioDataProvider.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/**
    This singletopne class provides data for all possible Tetramonios
 */

class TetramonioDataProvider {
    
    // MARK: - Singletone Stuff
    
    static let sharedProvider = TetramonioDataProvider()
    
    private init() {
   
    }
    
    // MARK: - Public Methods
    
    func parseTetramonios() -> [Tetramonio] {
        var tetromonios = [Tetramonio]()
        
        guard let path = Bundle.main.path(forResource: "Tetramonios", ofType: "plist") else {
            fatalError("Failed to parse Tetramonios plist")
        }
       
        guard let parsedTetramonios = NSArray(contentsOfFile: path) else {
            fatalError("Failed to create array from plist")
        }
        
        for tetramonio in parsedTetramonios {
            guard let teramonioData = tetramonio as? NSDictionary else {
                fatalError("Failed to parse teramonio dictionary")
            }
            let parsedTeramonio = Tetramonio(dictionary: teramonioData)
            tetromonios.append(parsedTeramonio)
        }
        return tetromonios
    }
}

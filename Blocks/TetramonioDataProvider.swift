//
//  TetramonioDataProvider.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/**
    This class provide data for all possible Tetramonios
 */

class TetremonioDataProvider: PlistDataProvider {
    
    // MARK: - Inizialization
    
    required init(resource: String = "Tetramonios") {
        super.init(resource: resource)
    }
    
    // MARK: - Public methods
    
    func getTetramonios() -> [Tetramonio] {
        var result = [Tetramonio]()
        let tetramonios = getArrayData()
        
        for tetramonio in tetramonios {
            guard let teramonioData = tetramonio as? NSDictionary else {
                fatalError("Failed to parse teramonio dictionary")
            }
            let parsedTeramonio = Tetramonio(dictionary: teramonioData)
            result.append(parsedTeramonio)
        }
        return result
    }
}

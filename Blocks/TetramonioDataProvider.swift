//
//  TetramonioDataProvider.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// This class provide data for all possible Tetramonios
class TetremonioDataProvider {

    // MARK: - Properties

    private let dataProvider: DataProvider

    // MARK: - Inizialization

    init(dataProvider: DataProvider = PlistDataProvider(resource: "Tetramonios", type: "plist")) {
        self.dataProvider = dataProvider
    }

    // MARK: - Public methods

    func getTetramonios() -> [Tetramonio] {
        var result = [Tetramonio]()
        guard let tetramonios: NSArray = dataProvider.getData() else {
            fatalError("Tetramonios is of wrong type")
        }

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

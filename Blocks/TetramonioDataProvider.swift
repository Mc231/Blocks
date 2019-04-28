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

	var tetramonios: [Tetramonio] {
        guard let tetramonios: NSArray = dataProvider.getData() else {
            fatalError("Tetramonios is of wrong type")
        }
		return tetramonios
			.reduce(into: [Tetramonio](), { (result, tetramonio) in
				guard let teramonioData = tetramonio as? NSDictionary else {
					fatalError("Failed to parse teramonio dictionary")
				}
				let parsedTetramonio = Tetramonio(dictionary: teramonioData)
				result.append(parsedTetramonio)
		})
    }
}

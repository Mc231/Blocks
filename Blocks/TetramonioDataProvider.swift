//
//  TetramonioDataProvider.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// This class load data for all possible Tetramonios
class TetremonioLoader {
	
	// MARK: - Constatns
	
	private static let fileName = "Tetramonios"
	private static let fileTpe = "plist"

    // MARK: - Properties

    private let resourceLoader: ResourceLoadable
	private let plistDecoder: PropertyListDecoder

    // MARK: - Inizialization

	init(resourceLoader: ResourceLoadable = BundleResourceLoader(bundle: .main),
		 plistDecoder: PropertyListDecoder = .init()) {
        self.resourceLoader = resourceLoader
		self.plistDecoder = plistDecoder
    }

    // MARK: - Public methods
	
	func load() -> Result<[Tetramonio], Error> {
		do {
			let data = try resourceLoader.load(resource: Self.fileName, type: Self.fileTpe).get()
			let result = try plistDecoder.decode([Tetramonio].self, from: data)
			return .success(result)
		}catch{
			print(error)
			return .failure(error)
		}
	}
}

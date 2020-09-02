//
//  TetramonioDataProvider.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetramonioLoadable {
	func load() throws -> [Tetramonio]
}

/// This class load data for all possible Tetramonios
class TetramonioLoader: TetramonioLoadable {
	
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
	
    func load() throws -> [Tetramonio] {
        let data = try resourceLoader.load(resource: Self.fileName, type: Self.fileTpe)
        return try plistDecoder.decode([Tetramonio].self, from: data)
	}
}

//
//  PlistDataProvider.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// Load resource from bundle
class BundleResourceLoader: ResourceLoadable {

    // MARK: - Properties

	private let bundle: Bundle

    // MARK: - Inizialization
	
	init(bundle: Bundle) {
		self.bundle = bundle
	}
	
	func load(resource: String, type: String) throws -> Data {
        guard let path = bundle.path(forResource: resource, ofType: type) else {
            throw ResourceLoadingError.invalidPath
        }
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        return data
	}
}

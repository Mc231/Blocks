//
//  PlistDataProvider.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

enum ResourceLoadingError: Error {
	case invalidPath
	case failedToParse
}

/// Basic plist data provider protocol
protocol ResourceLoadable: class {
	func load(resource named: String,
			  type: String) -> Result<Data, Error>
}

/// This class is Base data provider class
class BundleResourceLoader: ResourceLoadable {

    // MARK: - Properties

	private let bundle: Bundle

    // MARK: - Inizialization
	
	init(bundle: Bundle) {
		self.bundle = bundle
	}
	
	func load(resource: String,
			  type: String) -> Result<Data, Error> {
		guard let path = bundle.path(forResource: resource, ofType: type) else {
			let error: ResourceLoadingError = .invalidPath
			return .failure(error)
		}
		do {
			let url = URL(fileURLWithPath: path)
			let data = try Data(contentsOf: url)
			return .success(data)
		}catch{
			print(error)
			return .failure(ResourceLoadingError.failedToParse)
		}
	}

}

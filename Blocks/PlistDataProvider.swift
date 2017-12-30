//
//  PlistDataProvider.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// Basic plist data provider protocol
protocol DataProvider: class {
    init(resource: String, type: String)
    func getData<T>() -> T?
}

/// This class is Base data provider class
class PlistDataProvider: DataProvider {

    // MARK: - Properties

    private let resource: String
    private let path: String
    private let type: String

    // MARK: - Inizialization

    required init(resource: String, type: String) {
        self.resource = resource
        self.type = type
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            fatalError("Resource could not be nil")
        }
        self.path = path
    }

    func getData<T>() -> T? {
        guard let parsedData = NSArray(contentsOfFile: path) else {
            fatalError("Failed to parse data")
        }
        return parsedData as? T
    }
}

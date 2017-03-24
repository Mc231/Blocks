//
//  PlistDataProvider.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// Basic plist data provider protocol
protocol PlistDataProviderProcotcol: class {
    init(resource: String)
    func getArrayData() -> NSArray
}

/// This class is Base data provider class

class PlistDataProvider: PlistDataProviderProcotcol {
    
    // MARK: - Constants
    
    private let type = "plist"
    
    // MARK: - Properties
    
    private(set) var resource: String
    private(set) var path: String
    
    // MARK: - Inizialization
    
    required init(resource: String) {
        self.resource = resource
        
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            fatalError("Failed to parser")
        }
        self.path = path
    }
    
    // MARK: - Public methods
    
    func getArrayData() -> NSArray {
        guard let parsedData = NSArray(contentsOfFile: path) else {
            fatalError("Failed to parse array data")
        }
        return parsedData
    }
}

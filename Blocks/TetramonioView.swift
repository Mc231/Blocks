//
//  TetramonioView.swift
//  Blocks
//
//  Created by Volodya on 9/17/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

class TetramonioView: UIView {
    
    // MARK: - Constatns
    
    private let numberOfCellsInField = 16
    
    // MARK: - Variables
    
    fileprivate lazy var dataSource: [CellData] = [CellData]()
    
    fileprivate var cellSize: CGSize {
        let width = (self.bounds.width - 2) / 4
        let height = width
        return CGSize(width: width, height: height)
    }
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    }()
    
    // MARK: - Inizialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCollectionView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    // MARK: - Public methods
    
    public func update(with indexes: [Int]) {
        
        for (index, _) in dataSource.enumerated() {
            dataSource[index].chageState(newState: .empty)
        }
        
        indexes.forEach { (index) in
            dataSource[index].chageState(newState: .selected)
        }
        collectionView.reloadData()
    }
    
    // MARK: - Private functions
    
    private func configureCollectionView() {
        collectionView.register(FieldCell.nib, forCellWithReuseIdentifier: FieldCell.identifier)
        
        for _ in 0..<self.numberOfCellsInField {
            dataSource.append(CellData(state: .empty))
        }
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TetramonioView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}

// MARK: - UICollectionViewDelegate

extension TetramonioView: UICollectionViewDelegate { }


// MARK: - UICollectionViewDataSource

extension TetramonioView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FieldCell.identifier, for: indexPath) as? FieldCell else{
            fatalError("Could not deque cell")
        }
        
        cell.cellData = dataSource[indexPath.row]
        return cell
    }
}

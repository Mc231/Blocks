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

    private let numberOfCellsInField = 15
	private let isIphone5 = UIDevice.current.screenType == .iPhones5

	// MARK: - Variables

    fileprivate lazy var dataSource: [CellData] = [CellData]()

    fileprivate var cellSize: CGSize {
        let width = (self.bounds.width - 2) / 4
        let height = width
        return CGSize(width: width, height: height)
    }

	// TODO: - Remove magic numbers
    private lazy var collectinViwLayout: UICollectionViewFlowLayout = {
       var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        layout.itemSize = self.cellSize
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.collectinViwLayout)
        collectionView.backgroundColor = UIColor.white
		collectionView.isScrollEnabled = false
        collectionView.dataSource = self

        return collectionView
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

        for index in dataSource.indices {
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
		(0...numberOfCellsInField).forEach({_ in dataSource.append(CellData(state: .empty))})
        addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource

extension TetramonioView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
		-> UICollectionViewCell {

        guard let cell
			= collectionView.dequeueReusableCell(withReuseIdentifier: FieldCell.identifier, for: indexPath) as? FieldCell else {
            fatalError("Could not deque cell")
        }

        cell.cellData = dataSource[indexPath.row]
        return cell
    }
}

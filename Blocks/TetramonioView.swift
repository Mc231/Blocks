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

    private let kNumberOfCellsInField = 15
	private let kCellsMargin: CGFloat = 2
	private let kNumberOfCells: CGFloat = 4
	private let kLineSpacing: CGFloat = 0.5
	private let kInterimSpacing: CGFloat = 0.5

	// MARK: - Variables
	
	var selectedCells: [FieldCell] {
		return collectionView
			.subviews
			.compactMap({$0 as? FieldCell})
			.filter({$0.cellData.isSelected})
	}

    private lazy var dataSource: [CellData] = [CellData]()

    private var cellSize: CGSize {
        let width = (self.bounds.width - kCellsMargin) / kNumberOfCells
        let height = width
        return CGSize(width: width, height: height)
    }

    private lazy var collectinViwLayout: UICollectionViewFlowLayout = {
       var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kLineSpacing
        layout.minimumInteritemSpacing = kInterimSpacing
        layout.itemSize = self.cellSize
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.collectinViwLayout)
        collectionView.backgroundColor = UIColor.clear
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
			dataSource[index].chageState(newState: .clear)
        }

        indexes.forEach { (index) in
            dataSource[index].chageState(newState: .selected)
        }
        collectionView.reloadData()
    }

    // MARK: - Private functions

    private func configureCollectionView() {
        collectionView.register(FieldCell.nib, forCellWithReuseIdentifier: FieldCell.identifier)
		(0...kNumberOfCellsInField).forEach({_ in dataSource.append(CellData(state: .empty))})
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

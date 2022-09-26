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
	private let kInterimSpacing: CGFloat = 2
	private let kSideMargin = 16

	// MARK: - Variables
	
	var selectedCells: [FieldCollectionViewCell] {
		return collectionView
			.subviews
			.compactMap({$0 as? FieldCollectionViewCell})
			.filter({$0.cellData.isSelected})
	}

    private lazy var dataSource: [FieldCell] = [FieldCell]()

    private var cellSize: CGSize {
        let width = ((UIScreen.main.bounds.width / 2) - 18 - 4) / kNumberOfCells // Side margin 18 and cell spacing 4
        let height = width
        return CGSize(width: width, height: height)
    }

    private lazy var collectinViwLayout: UICollectionViewFlowLayout = {
       var layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = kInterimSpacing
		layout.minimumInteritemSpacing = .zero
        layout.itemSize = self.cellSize
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
		let side = (Int(UIScreen.main.bounds.width) / 2) - kSideMargin
		let size = CGSize(width: side, height: side)
		let frame = CGRect(origin: .zero, size: size)
		var collectionView = UICollectionView(frame: frame, collectionViewLayout: self.collectinViwLayout)
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
        collectionView.register(FieldCollectionViewCell.self, forCellWithReuseIdentifier: FieldCollectionViewCell.identifier)
		(0...kNumberOfCellsInField).forEach({_ in dataSource.append(FieldCell(state: .empty))})
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
			= collectionView.dequeueReusableCell(withReuseIdentifier: FieldCollectionViewCell.identifier, for: indexPath) as? FieldCollectionViewCell else {
            fatalError("Could not deque cell")
        }
		let cellData = dataSource[indexPath.row]
        cell.apply(cellData: cellData)
        return cell
    }
}

//
//  GameInfoView.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Constants

    private static let gameOverTitle = Localization.GameOverAlert.title.localized
    private static let restartTitle = Localization.General.restart.localized

    // MARK: - Variables

    var presenter: GameViewOutput?
	
	private var firstTetramonioDraggedChcker: DraggedTetramonioChecker!
	private var secondTetramonioDraggedChcker: DraggedTetramonioChecker!
    private var tetramonios = [Tetramonio]()
    private var fieldData = [FieldCell]() {
        didSet {
            field.reloadData()
        }
    }

	static var instance: GameViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
    }

    // MARK: - IBOutlets

    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var firstTetramonioView: TetramonioView = {
        let tetramonioView = TetramonioView()
        tetramonioView.isUserInteractionEnabled = true
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragTetramonio2(_:)))
        return tetramonioView
    }()
    
    private lazy var secondTetramonioView: TetramonioView = {
        let tetramonioView = TetramonioView()
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragTetramonio2(_:)))
        tetramonioView.addGestureRecognizer(recognizer)
        return tetramonioView
    }()
    
    
    private lazy var field: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()


	// MARK: - UIViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
		firstTetramonioDraggedChcker = DraggedTetramonioChecker(field: field, view: firstTetramonioView)
		secondTetramonioDraggedChcker = DraggedTetramonioChecker(field: field, view: secondTetramonioView)
        presenter?.startGame()
        field.register(FieldCollectionViewCell.self, forCellWithReuseIdentifier: FieldCollectionViewCell.identifier)
      
    }
    
    private func setupView() {
        view.isUserInteractionEnabled = false
        //view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(field)
        view.addSubview(headerView)
  
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16.0).isActive = true
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        field.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 2.0).isActive = true
        field.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        field.heightAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1.0).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [firstTetramonioView, secondTetramonioView])

        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 2.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: field.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: field.trailingAnchor).isActive = true
    }

    // MARK: - IBActions

	@objc private func didDragTetramonio1(_ sender: UIPanGestureRecognizer) {
		handleDraggedTetramonio(checker: firstTetramonioDraggedChcker, sender: sender)
	}
	
	@objc private func didDragTetramonio2(_ sender: UIPanGestureRecognizer) {
		handleDraggedTetramonio(checker: secondTetramonioDraggedChcker, sender: sender)
	}
	
    // MARK: - Touches methods
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouchForEvent(event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleTouchForEvent(event)
    }

    // MARK: - Private methods
	
	private func handleDraggedTetramonio(checker: DraggedTetramonioChecker, sender: UIPanGestureRecognizer) {
        presenter?.invalidateSelectedCells()
		checker.handleDraggedTetramonio(from: sender) { [weak self] cells in
            self?.presenter?.handleDraggedCell(with: cells)
		}
	}

    private func handleTouchForEvent(_ event: UIEvent?) {

        guard let touchPoint = event?.allTouches?.first?.location(in: field) else {
            debugPrint("Touch point is outside of the field \(#line)")
            return
        }

        field
            .subviews
            .filter({$0 is FieldCollectionViewCell && $0.frame.contains(touchPoint)})
			.compactMap({$0 as? FieldCollectionViewCell})
            .forEach({presenter?.handleTouchedCell(with: $0.cellData)})
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
	// swiftlint:disable vertical_parameter_alignment
    func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return Constatns.Sizes.calculateFieldCellSize(frame: collectionView.frame)
    }
}

// MARK: - HeaderViewDelegate

extension GameViewController: HeaderViewDelegate {
    
    func didTapMenue() { }
    
    func didTapRestart() {
        presenter?.restartGame()
    }
}

// MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constatns.Field.numberOfCellsOnField
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
		-> UICollectionViewCell {

        guard let cell =
			collectionView.dequeueReusableCell(withReuseIdentifier: FieldCollectionViewCell.identifier, for: indexPath) as? FieldCollectionViewCell else {
            fatalError("Could not deque cell")
        }
        let cellData = fieldData[indexPath.row]
        cell.apply(cellData: cellData)
        return cell
    }
}

// MARK: - GameViewInput

extension GameViewController: GameViewInput {

    func showGameOverAlert(currentScore: Score) {
        let message = Localization.GameOverAlert.message(currentScore).localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Self.restartTitle, style: .destructive) { [weak self] (_) in
            self?.presenter?.restartGame()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func display(field withData: [FieldCell]) {
		if fieldData.isEmpty {
			fieldData = withData
			field.reloadData()
		}else{
			let indexesToReload: [IndexPath] = withData.reduce(into: [IndexPath]()) { (result, data) in
				if let index = fieldData.firstIndex(of: data) {
					fieldData[index] = data
					result.append(IndexPath(row: index, section: 0))
				}
			}
			field.reloadItems(at: indexesToReload)
    	}
	}

    func display(tetramonios: [Tetramonio]) {
        firstTetramonioView.update(with: tetramonios.first!.displayTetramonioIndexes)
        secondTetramonioView.update(with: tetramonios.last!.displayTetramonioIndexes)
    }

	func displayScore(score: GameScore) {
        headerView.update(score: score)
    }
}

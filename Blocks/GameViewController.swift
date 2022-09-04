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
    private static let restartTitle = Localization.GameOverAlert.restartTitle.localized

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

    @IBOutlet private weak var maxScoreLabel: UILabel!
    @IBOutlet private weak var currentScoreLabel: UILabel!
    @IBOutlet private weak var firstTetramonioView: TetramonioView!
    @IBOutlet private weak var secondTetramonioView: TetramonioView!
    @IBOutlet private weak var field: UICollectionView!


	// MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
		firstTetramonioDraggedChcker = DraggedTetramonioChecker(field: field, view: firstTetramonioView)
		secondTetramonioDraggedChcker = DraggedTetramonioChecker(field: field, view: secondTetramonioView)
        presenter?.startGame()
        field.register(FieldCollectionViewCell.nib, forCellWithReuseIdentifier: FieldCollectionViewCell.identifier)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        field.collectionViewLayout.invalidateLayout()
    }

    // MARK: - IBActions

    @IBAction private func restartGame(sender: UIButton) {
        presenter?.restartGame()
    }

	@IBAction private func didDragTetramonio1(_ sender: UIPanGestureRecognizer) {
		handleDraggedTetramonio(checker: firstTetramonioDraggedChcker, sender: sender)
	}
	
	@IBAction private func didDragTetramonio2(_ sender: UIPanGestureRecognizer) {
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
		checker.handleDraggedTetramonio(from: sender) { [weak self] cells in
			if !cells.isEmpty {
				self?.presenter?.handleDraggedCell(with: cells)
			}
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
		return Constatns.Sizes.calculateFieldCellSize()
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
        currentScoreLabel.text = Localization.Score.score(score.current).localized
        maxScoreLabel.text = Localization.Score.best(score.best).localized
    }
}

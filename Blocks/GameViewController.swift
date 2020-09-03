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

    private static let numberOfRows = 8
    private static let cellWidthCoof: CGFloat = 0.1173
    private static let gameOverTitle = Localization.Game.GameOverAlert.title.localization
    private static let restartTitle = Localization.Game.GameOverAlert.restartTitle.localization

    // MARK: - Variables

	// TODO: - Refactore
	var draggedChcker: DraggedTetramonioChecker!
    var presenter: GameViewOutput?
    var tetramonios = [Tetramonio]()
    var fieldData = [CellData]() {
        didSet {
            field.reloadData()
        }
    }

    var cellSize: CGSize {
        let width = Int(UIScreen.main.bounds.size.width - UIScreen.main.bounds.width * Self.cellWidthCoof) / Self.numberOfRows
        let height = width
        return CGSize(width: width, height: height)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var maxScoreLabel: UILabel!
    @IBOutlet private weak var currentScoreLabel: UILabel!
    @IBOutlet private weak var firstTetramonioView: TetramonioView!
    @IBOutlet private weak var secondTetramonioView: TetramonioView!
    @IBOutlet private weak var field: UICollectionView!

    // MARK: - Inizialization

    override func awakeFromNib() {
        super.awakeFromNib()
        GameAssambler.assamble(in: self)
		//draggedChcker = DraggedTetramonioChecker(field: field, view: self.view)
    }

	// MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.startGame()
        field.register(FieldCell.nib, forCellWithReuseIdentifier: FieldCell.identifier)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        field.collectionViewLayout.invalidateLayout()
    }

    // MARK: - IBActions

    @IBAction private func restartGame(sender: UIButton) {
        presenter?.restartGame()
    }
	// TODO: - Remove this
	var initialCenter = CGPoint()
	var initialWidth = CGFloat.leastNonzeroMagnitude
	
	// TODO: - Refactore this
	@IBAction private func didTapTetramonio1(_ sender: UIPanGestureRecognizer) {
		guard let piece = sender.view as? TetramonioView else { return }

		// Get the changes in the X and Y directions relative to
		// the superview's coordinate space.
		let translation = sender.translation(in: piece.superview)
		if sender.state == .began {
			// Save the view's original position.
			field.layer.zPosition = -1
			self.initialCenter = CGPoint(x: piece.center.x, y: piece.center.y - 80.0)
			self.initialWidth = piece.frame.width
			let coof = (field.frame.width / 2) / initialWidth
			piece.transform = CGAffineTransform(scaleX: coof, y: coof)
		}else if sender.state == .changed {
		//	print("Changed")
		}
		// Update the position for the .began, .changed, and .ended states
		if sender.state != .ended {
			// Add the X and Y translation to the view's original position.
			let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
			piece.center = newCenter
		}else{
			// TODO : - Refacore
			let matchedTetramoino = field
				.subviews
				.compactMap({$0 as? FieldCell})
				.reduce(into: [CellData]()) { (result, fieldCell) in
					piece.selectedCells.forEach({ (tetramonioCell) in
						let fieldRect = fieldCell.convert(fieldCell.bounds, to: self.view)
						let tetramonioRect = tetramonioCell.convert(tetramonioCell.bounds, to: self.view)
						let intersectRect = fieldRect.intersection(tetramonioRect)
						let intersectsTetramonioRect = fieldRect.intersects(tetramonioRect)
						let intersectRectSzie = intersectRect.width >= 32 && intersectRect.height >= 32
						if  intersectsTetramonioRect && intersectRectSzie,
							let data = fieldCell.cellData {
							if !result.contains(data) {
								result.append(data)
							}
						}
					})
				}
		
			
			// On cancellation, return the piece to its original location.
			UIView.animate(withDuration: 0.3) {
				self.field.layer.zPosition = 1
				piece.center = self.initialCenter
				let coof = self.initialWidth / piece.bounds.width
				piece.transform = CGAffineTransform(scaleX: coof, y: coof)
			}
		}
	}
	
	@IBAction private func didTapTetramonio2(_ sender: UIPanGestureRecognizer) {
		didTapTetramonio1(sender)
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

    private func handleTouchForEvent(_ event: UIEvent?) {

        guard let touchPoint = event?.allTouches?.first?.location(in: field) else {
            debugPrint("Touch point is outside of the field \(#line)")
            return
        }

        field
            .subviews
            .filter({$0 is FieldCell && $0.frame.contains(touchPoint)})
			.compactMap({$0 as? FieldCell})
            .forEach({presenter?.handleTouchedCell(with: $0.cellData)})
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
	// swiftlint:disable vertical_parameter_alignment
    func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
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
			collectionView.dequeueReusableCell(withReuseIdentifier: FieldCell.identifier, for: indexPath) as? FieldCell else {
            fatalError("Could not deque cell")
        }

        cell.cellData = fieldData[indexPath.row]
        return cell
    }
}

// MARK: - GameViewInput

extension GameViewController: GameViewInput {

    func showGameOverAlert(currentScore: Score) {
        let message = Localization.Game.GameOverAlert.message(currentScore).localization
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Self.restartTitle, style: .destructive) { [weak self] (_) in
            self?.presenter?.restartGame()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func display(field withData: [CellData]) {
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

        guard let firstTetramonioIndexes = tetramonios.first?.displayTetramonioIndexes,
              let secondTetramonioIndexes = tetramonios.last?.displayTetramonioIndexes else {
                fatalError("Imposible Tetramonio indexes")
        }

        firstTetramonioView.update(with: firstTetramonioIndexes)
        secondTetramonioView.update(with: secondTetramonioIndexes)
    }

	func displayScore(score: GameScore) {
        currentScoreLabel.text = Localization.Game.Score.current(score.current).localization
        maxScoreLabel.text = Localization.Game.Score.best(score.best).localization
    }
}

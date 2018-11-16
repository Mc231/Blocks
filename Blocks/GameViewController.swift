//
//  GameInfoView.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

// MARK: - Check this

protocol GameViewOutput {
	var view: GameViewInput? { get set }
    func startGame()
    func restartGame()
    func handleTouchedCell(with data: CellData)
}

protocol GameViewInput: class {
	var presenter: GameViewOutput? { get set }
    func display(tetramonios: [Tetramonio])
    func display(field withData: [CellData])
    func displayScore(current: Int32, best: Int32)
    func showGameOverAlert(currentScore: Int32)
}

class GameViewController: UIViewController {

    // MARK: - Constants

    fileprivate let numberOfRows = 8
    private let cellWidthCoof: CGFloat = 0.1173

    // MARK: - Variables

    var presenter: GameViewOutput?
    var tetramonios = [Tetramonio]()
    var fieldData = [CellData]() {
        didSet {
            field.reloadData()
        }
    }

    var cellSize: CGSize {
        let width = Int(UIScreen.main.bounds.size.width - UIScreen.main.bounds.width * cellWidthCoof) / numberOfRows
        let height = width
        return CGSize(width: width, height: height)
    }

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var maxScoreLabel: UILabel!
    @IBOutlet fileprivate weak var currentScoreLabel: UILabel!
    @IBOutlet fileprivate weak var firstTetramonioView: TetramonioView!
    @IBOutlet fileprivate weak var secondTetramonioView: TetramonioView!
    @IBOutlet fileprivate weak var field: UICollectionView!

    // MARK: - Inizialization

    override func awakeFromNib() {
        super.awakeFromNib()
        GameAssambler.configureGameModule(in: self)
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
	
	var initialCenter = CGPoint()
	var initialWidth = CGFloat.leastNonzeroMagnitude
	
	@IBAction private func didTapTetramonio1(_ sender: UIPanGestureRecognizer) {
		guard let piece = sender.view as? TetramonioView else {return}
		// Get the changes in the X and Y directions relative to
		// the superview's coordinate space.
		let translation = sender.translation(in: piece.superview)
		if sender.state == .began {
			// Save the view's original position.
			field.layer.zPosition = -1
			piece.isDragging = true
			self.initialCenter = piece.center
			self.initialWidth = piece.frame.width
			let coof = (field.frame.width / 2) / initialWidth
			piece.transform = CGAffineTransform(scaleX: coof, y: coof)
		}
		// Update the position for the .began, .changed, and .ended states
		if sender.state != .ended {
			// Add the X and Y translation to the view's original position.
			let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
			piece.center = newCenter
		}
		else {
			// On cancellation, return the piece to its original location.
			UIView.animate(withDuration: 0.3) {
				self.field.layer.zPosition = 1
				piece.isDragging = false
				piece.center = self.initialCenter
				let coof = self.initialWidth / piece.bounds.width
				piece.transform = CGAffineTransform(scaleX: coof, y: coof)
			}
		}

	}
	
	@IBAction private func didTapTetramonio2(_ sender: UIPanGestureRecognizer) {
		
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

    func showGameOverAlert(currentScore: Int32) {
        let title = Localization.Game.GameOverAlert.title.localization
        let message = Localization.Game.GameOverAlert.message(currentScore).localization
        let restartActionTitle = Localization.Game.GameOverAlert.restartTitle.localization
        let cancelActionTitle = Localization.Game.GameOverAlert.cancelTitle.localization
        showAlert(title: title,
				  message: message, okActionTitle: restartActionTitle, cancelActionTitle: cancelActionTitle) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.restartGame()
        }
    }

    func display(field withData: [CellData]) {
        fieldData = withData
        field.reloadData()
    }

    func display(tetramonios: [Tetramonio]) {

        guard let firstTetramonioIndexes = tetramonios.first?.displayTetramonioIndexes,
              let secondTetramonioIndexes = tetramonios.last?.displayTetramonioIndexes else {
                fatalError("Imposible Tetramonio indexes")
        }

        firstTetramonioView.update(with: firstTetramonioIndexes)
        secondTetramonioView.update(with: secondTetramonioIndexes)
    }

    func displayScore(current: Int32, best: Int32) {
        currentScoreLabel.text = Localization.Game.Score.current(current).localization
        maxScoreLabel.text = Localization.Game.Score.best(best).localization
    }
}

// MARK: - AlertShowable

extension GameViewController: AlertPresenter { }

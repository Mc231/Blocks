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
    func startGame()
    func restartGame()
    func handleTouchedCell(with data: CellData)
}

protocol GameViewInput: class {
    func display(tetramonios: [Tetramonio])
    func display(field withData: [CellData])
    func displayScore(current: Int32, best: Int32)
    func showGameOverAlert(currentScore: Int32)
}

class GameViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var firstTetramonioView: TetramonioView!
    @IBOutlet weak var secondTetramonioView: TetramonioView!
    @IBOutlet weak var field: UICollectionView!
    
    // MARK: - Properties
    
    var presenter: GameViewOutput?
    var tetramonios = [Tetramonio]()
    var fieldData = [CellData]() {
        didSet{
            field.reloadData()
        }
    }
    
    var cellSize: CGSize {
        // TODO: - Fix this
        let width = Int(UIScreen.main.bounds.size.width - UIScreen.main.bounds.width * 0.1173) / numberOfRows
        let height = width
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Constants
    
    fileprivate let numberOfRows = 8

    // MARK: - Inizialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GameAssambler.configureGameModule(in: self)
    }
    
    // MARK - UIViewController
    
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
    
    @IBAction func restartGame(sender: UIButton) {
        presenter?.restartGame()
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
            .flatMap({$0 as? FieldCell})
            .forEach({presenter?.handleTouchedCell(with: $0.cellData)})
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

// MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constatns.Field.numberOfCellsOnField;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FieldCell.identifier, for: indexPath) as? FieldCell else{
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
        showAlert(title: title, message: message, okActionTitle: restartActionTitle, cancelActionTitle: cancelActionTitle) { [weak self] in
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

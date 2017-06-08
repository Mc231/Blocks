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
    @IBOutlet weak var firstTetramonioImageView: UIImageView!
    @IBOutlet weak var secondTetramonioImageView: UIImageView!
    @IBOutlet weak var field: UICollectionView!
    
    // MARK: - Properties
    
    var presenter: GameViewOutput?
    var tetramonios = [Tetramonio]()
    var fieldData = [CellData]() {
        didSet{
            field.reloadData()
        }
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
        let touches = event?.allTouches?.first
        
        guard let touchPoint = touches?.location(in: field) else {
            debugPrint("Touch point is nil \(#line)")
            return
        }
        
        for (_, view) in field.subviews.enumerated() {
            if view is FieldCell && view.frame.contains(touchPoint) {
                guard let cell = view as? FieldCell else {
                    debugPrint("Failed to cast to FieldCell \(#line)")
                    return
                }
                presenter?.handleTouchedCell(with: cell.cellData)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(UIScreen.main.bounds.size.width) / numberOfRows
        let height = width
        return CGSize(width: width, height: height)
    }
}

// MARK: - GameViewInput

extension GameViewController: GameViewInput {

    func showGameOverAlert(currentScore: Int32) {
        let title = Localization.Game.GameOverAlert.title.localization
        let message = Localization.Game.GameOverAlert.message(currentScore).localization
        let restartActionTitle = Localization.Game.GameOverAlert.restartTitle.localization
        let cancelActionTitle = Localization.Game.GameOverAlert.cancelTitle.localization
        AlertManager.show(in: self, title: title, message: message, okActionTitle: restartActionTitle, cancelActionTitle: cancelActionTitle) { [weak self] in
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
    
        guard let firstImageId = tetramonios.first?.id.rawValue,
            let secondImageId = tetramonios.last?.id.rawValue else {
                fatalError("Imposible image id")
        }
  
        firstTetramonioImageView.image = UIImage(named: String(describing: firstImageId))
        secondTetramonioImageView.image = UIImage(named: String(describing: secondImageId))
    }
    
    func displayScore(current: Int32, best: Int32) {
        // TODO: - Localize this and rename label
        currentScoreLabel.text = Localization.Game.Score.current(current).localization
        maxScoreLabel.text = Localization.Game.Score.best(best).localization
    }
}

// MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FieldCell.cellIdentifier, for: indexPath) as? FieldCell else{
            fatalError("Could not deque cell")
        }

        cell.cellData = fieldData[indexPath.row]
        
        return cell
    }
}

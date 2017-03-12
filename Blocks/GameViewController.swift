//
//  GameInfoView.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Check this

protocol GameViewOutput {
    func generateTetramonios()
    func restartGame()
    func getMaxScore()
    func getCurrentScore()
    func handleTouchedCellWithData(_ cellData: CellData)
}

protocol GameViewInput: class {
    func displayTetramonios(_ tetramonios: [Tetramonio])
    func displayMaxScore(_ score: Int)
    func displayCurrentScore(_ score: Int)
    func updateCells(with cellData: [CellData])
}

class GameViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var field: UICollectionView!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    // MARK: - Properties
    
    var presenter: GameViewOutput!
    var tetramonios = [Tetramonio]()

    // MARK: - Inizialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GameAssambler.sharedInstance.configureGameInfoModule(view: self)
        presenter.generateTetramonios()
        updateScore()
    }
    
    // MARK: - IBActions
    
    @IBAction func restartGame(sender: UIButton) {
        presenter.restartGame()
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
    
    private func updateScore() {
        presenter.getCurrentScore()
        presenter.getMaxScore()
    }
    
    private func handleTouchForEvent(_ event: UIEvent?) {
        let touches = event?.allTouches?.first
        
        guard let touchPoint = touches?.location(in: field) else {
            debugPrint("Touch point is nil \(#line)")
            return
        }
        
        for (_, view) in view.subviews.enumerated() {
            if view is FieldCell && view.frame.contains(touchPoint) {
                guard let cell = view as? FieldCell else {
                    debugPrint("Failed to cast to FieldCell \(#line)")
                    return
                }
                presenter.handleTouchedCellWithData(<#T##cellData: CellData##CellData#>)
            }
        }
    }
}

// MARK: - GameViewInput

extension GameViewController: GameViewInput {
    
    func updateCells(with cellData: [CellData]) {
        
    }

    func displayTetramonios(_ tetramonios: [Tetramonio]) {
        print("Tetramomniso")
    }
    
    func displayCurrentScore(_ score: Int) {
        let scoreToSet = String(score)
        currentScoreLabel.text = scoreToSet
    }
    
    func displayMaxScore(_ score: Int) {
        let scoreToSet = String(score)
        maxScoreLabel.text = scoreToSet
    }
}

// MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

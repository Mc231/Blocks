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
    func generateTetramonios()
    func createField()
    func restartGame()
    func getMaxScore()
    func getCurrentScore()
    func handleTouchedCell(with data: CellData)
}

protocol GameViewInput: class {
    func display(tetramonios: [Tetramonio])
    func display(field withData: [CellData])
    func display(max score: Int)
    func display(current score: Int)
    func update(cellData: [CellData])
}

class GameViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var figure1ImageView: UIImageView!
    @IBOutlet weak var figure2ImageView: UIImageView!
    @IBOutlet weak var field: UICollectionView!
    
    // MARK: - Properties
    
    var presenter: GameViewOutput!
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
        GameAssambler.sharedInstance.configureGameInfoModule(view: self)
    }
    
    // MARK - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.generateTetramonios()
        presenter.createField()
        updateScore()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        field.collectionViewLayout.invalidateLayout()
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
        
        for (_, view) in field.subviews.enumerated() {
            if view is FieldCell && view.frame.contains(touchPoint) {
                guard let cell = view as? FieldCell else {
                    debugPrint("Failed to cast to FieldCell \(#line)")
                    return
                }
                presenter.handleTouchedCell(with: cell.cellData)
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
    
    func update(cellData: [CellData]) {
        fieldData = cellData
        field.reloadData()
    }
    
    func display(field withData: [CellData]) {
        fieldData = withData
    }

    func display(tetramonios: [Tetramonio]) {
        print("Tetramomniso")
    }
    
    func display(current score: Int) {
        let scoreToSet = String(score)
        debugPrint(scoreToSet)
        currentScoreLabel.text = scoreToSet
    }
    
    func display(max score: Int) {
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FieldCell.cellIdentifier, for: indexPath) as? FieldCell else{
            fatalError("Could not deque cell")
        }

        cell.cellData = fieldData[indexPath.row]
        
        return cell
    }
}

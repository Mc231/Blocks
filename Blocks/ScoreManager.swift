//
//  ScoreManager.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol ScoreManagerProtocol {
    func setScore(_ score: Int, callback: (String,String,Bool) -> ())
    func getCurrentScore() -> String
    func getBestScore() -> String
    func resetCurrentScore() -> String
}

class ScoreManager: ScoreManagerProtocol {
    
    // WARNING: - Add core data service for feching and saving max score
    
    // MARK: - Properties
    
    private var currentScore: Int
    private var bestScore: Int
    
    // MARK: - Inizialization
    
    init() {
        self.currentScore = 0
        self.bestScore = 0
    }
    
    func setScore(_ score: Int, callback: (String, String, Bool) -> ()) {
        currentScore += score
        
        if currentScore > bestScore {
            bestScore = currentScore
        }
        // WARNING: - Make this string localizble
        
        let score = "Score: \(currentScore)"
        let maxScore = "Best: \(bestScore)"
        
        callback(score, maxScore, true)
    }
    
    func getCurrentScore() -> String {
        return "Score: \(currentScore)"
    }
    
    func getBestScore() -> String {
        return "Best: \(bestScore)"
    }
    
    func resetCurrentScore() -> String {
        currentScore = 0
        return "Score: \(currentScore)"
    }
}

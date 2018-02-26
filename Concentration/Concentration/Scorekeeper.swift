//
//  Scorekeeper.swift
//  Concentration
//
//  Created by Titas Datta on 27/02/18.
//  Copyright © 2018 Titas Datta. All rights reserved.
//

import Foundation
class Scorekeeper {
    var totalScore = 0
    var mismatchedCards: [Int] = []
    var startTime = Date()
    
    func updateScore(for cards: [Int], didMatch: Bool) {
        if didMatch {
            totalScore += 2
        } else {
            let setOfCards = Set(cards)
            let setOfMismatchedCards = Set(mismatchedCards)
            if setOfCards.isSubset(of: setOfMismatchedCards) {
                totalScore -= 1
            }
            mismatchedCards.append(contentsOf: cards)
        }
    }
    
    func updateTimerScore(){
        let timeInterval = startTime.timeIntervalSinceNow
        totalScore -= (Int(timeInterval) % 10) 
    }
    
    func startNewGame(){
        totalScore = 0;
        mismatchedCards = []
        startTime = Date()
    }
}

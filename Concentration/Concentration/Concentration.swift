//
//  Concentration.swift
//  Concentration
//
//  Created by Titas Datta on 25/02/18.
//  Copyright © 2018 Titas Datta. All rights reserved.
//

import Foundation
import GameKit

class Concentration {
    
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    var scoreKeeper: Scorekeeper = Scorekeeper()
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreKeeper.updateScore(for: [cards[matchIndex].identifier], didMatch: true)
                }else {
                    scoreKeeper.updateScore(for: [cards[matchIndex].identifier, cards[index].identifier], didMatch: false)
                }
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for faceDownCardIndex in cards.indices {
                    cards[faceDownCardIndex].isFaceUp = false
                }
                indexOfOneAndOnlyFaceUpCard = index
            }
            cards[index].isFaceUp = true
        }
        if areAllCardsMatched() {
            scoreKeeper.updateTimerScore()
        }
    }
    
    func areAllCardsMatched() -> Bool {
        var result = true
        for card in cards {
            if card.isMatched == false {
                result = false
                break
            }
        }
        return result
    }
    
    func startNewGame() {
        for i in cards.indices {
            cards[i].isMatched = false
            cards[i].isFaceUp = false
        }
        scoreKeeper.startNewGame()
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        //TODO: Shuffle the cards
        cards = shuffleCards(forCards: cards)
    }
    
    func shuffleCards(forCards cards: [Card]) -> [Card] {
       return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
    }
}

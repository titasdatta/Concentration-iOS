//
//  Concentration.swift
//  Concentration
//
//  Created by Titas Datta on 25/02/18.
//  Copyright © 2018 Titas Datta. All rights reserved.
//

import Foundation
import GameKit

struct Concentration {
    
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp == true }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    var scoreKeeper: Scorekeeper = Scorekeeper()
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not in cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreKeeper.updateScore(for: [cards[matchIndex]], didMatch: true)
                }else {
                    scoreKeeper.updateScore(for: [cards[matchIndex], cards[index]], didMatch: false)
                }
                
            } else {
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
    
    mutating func startNewGame() {
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

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

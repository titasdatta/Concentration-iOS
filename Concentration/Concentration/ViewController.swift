//
//  ViewController.swift
//  Concentration
//
//  Created by Titas Datta on 25/02/18.
//  Copyright © 2018 Titas Datta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var currentGameTheme: GameTheme? {
        didSet {
            flipCountLabel.textColor = currentGameTheme?.cardBackFaceColor
            self.view.backgroundColor = currentGameTheme?.backgroundColor
            for buttons in cardButtons {
                buttons.backgroundColor = currentGameTheme?.cardBackFaceColor
                buttons.isEnabled = true
            }
            scoreLabel.textColor = currentGameTheme?.cardBackFaceColor
            timerLabel.textColor = currentGameTheme?.cardBackFaceColor
        }
    }
    var currentEmojiChoices: [String] = []
    
    let themeManager: ThemeManager = ThemeManager()
    
    var flipsCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipsCount)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.isHidden = true
        scoreLabel.text = "Total Score: \(game.scoreKeeper.totalScore)"
        updateUI(for: themeManager.chooseRandomGameTheme())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchCard(_ sender: UIButton) {
        flipsCount += 1
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else {
            print("Corresponding card not present in cardButtons")
        }
        
        //Making new game button visible when all cards are matched
        if game.areAllCardsMatched() == true {
            newGameButton.isHidden = false
        }
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    func startNewGame() {
        game.startNewGame()
        updateUI(for: themeManager.chooseRandomGameTheme())
        updateViewFromModel()
        flipsCount = 0
        newGameButton.isHidden = true
        emoji = [:]
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let card = game.cards[index]
            let button = cardButtons[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitle(emoji(for: card), for: .normal)
            }else {
                button.setTitle("", for: .normal)
                if card.isMatched {
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    button.isEnabled = false
                } else {
                    button.backgroundColor = currentGameTheme?.cardBackFaceColor
                }
            }
        }
        scoreLabel.text = "Total Score: \(game.scoreKeeper.totalScore)"
    }
    
    var emoji = [Int: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, currentEmojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32( currentEmojiChoices.count)))
            emoji[card.identifier] =  currentEmojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    func updateUI(for theme: GameTheme){
        self.currentGameTheme = theme
        if let emojiChoices = self.currentGameTheme?.emojiChoices {
            self.currentEmojiChoices = emojiChoices
        }
    }
    
}


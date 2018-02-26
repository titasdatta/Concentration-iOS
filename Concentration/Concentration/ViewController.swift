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
    
    var gameThemes: [GameThemes]?
    var currentGameTheme: GameThemes? {
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
    
    var flipsCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipsCount)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.isHidden = true
        scoreLabel.text = "Total Score: \(game.scoreKeeper.totalScore)"
        gameThemes = [GameThemes(emojiChoices: emojiChoicesHalloween, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardBackFaceColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
                      GameThemes(emojiChoices: emojiChoicesAnimals, backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
                      GameThemes(emojiChoices: emojiChoicesObjects, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
                      GameThemes(emojiChoices: emojiChoicesFood, backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)),
                      GameThemes(emojiChoices: emojiChoicesFaces, backgroundColor: #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)),
                      GameThemes(emojiChoices: emojiChoicesSports, backgroundColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))]
        chooseRandomGameTheme(fromThemes: gameThemes!)
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
        chooseRandomGameTheme(fromThemes: gameThemes!)
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
    
    var emojiChoicesHalloween = ["👻", "🎃", "🦇", "😱", "🙀", "👹", "😈", "🍭", "🐺"]
    var emojiChoicesAnimals = ["🐶", "🐱", "🐹", "🦊", "🐻", "🐼" ,"🐯" ,"🦁", "🐵"]
    var emojiChoicesSports = ["⚽️", "🏀", "🏈", "🎾", "🏹", "🏓", "🎱", "🏑", "🏸"]
    var emojiChoicesFaces = ["😀", "☺️", "🤪", "😘", "😞", "🤯", "🤔", "😡", "😎"]
    var emojiChoicesFood = ["🍏", "🍓", "🍆", "🥞", "🍐", "🍋", "🍇", "🥝", "🥕"]
    var emojiChoicesObjects = ["⌚️", "📷", "⏰", "🎥", "💻", "🔦", "⚒", "☎️", "🖨"]
    
    struct GameThemes {
        var emojiChoices: [String]
        var backgroundColor: UIColor
        var cardBackFaceColor: UIColor
        
        init(emojiChoices: [String], backgroundColor: UIColor, cardBackFaceColor: UIColor) {
            self.emojiChoices = emojiChoices
            self.backgroundColor = backgroundColor
            self.cardBackFaceColor = cardBackFaceColor
        }
    }
    
    
    var emoji = [Int: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, currentEmojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32( currentEmojiChoices.count)))
            emoji[card.identifier] =  currentEmojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    func chooseRandomGameTheme(fromThemes gameThemes: [GameThemes]){
        let randomIndex = Int(arc4random_uniform(UInt32(gameThemes.count)))
        currentGameTheme = gameThemes[randomIndex]
        currentEmojiChoices = (currentGameTheme?.emojiChoices)!
    }
    
}


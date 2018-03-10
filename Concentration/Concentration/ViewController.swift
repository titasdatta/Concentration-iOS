//
//  ViewController.swift
//  Concentration
//
//  Created by Titas Datta on 25/02/18.
//  Copyright © 2018 Titas Datta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    
    private var startTime = TimeInterval()
    private var timer = Timer()
    
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return ((cardButtons.count + 1) / 2)
    }
    
    var currentGameTheme: GameTheme? 
    var currentEmojiChoices: [String] = []
    
    let themeManager: ThemeManager = ThemeManager()
    
    var flipsCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.isHidden = true
        scoreLabel.text = "Total Score: \(game.scoreKeeper.totalScore)"
        updateUI(for: themeManager.chooseRandomGameTheme())
        startTimer()
    }
    
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : currentGameTheme?.cardBackFaceColor ?? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipsCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
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
            stopTimer()
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
        startTimer()
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
                    button.isEnabled = true
                }
            }
        }
        scoreLabel.text = "Total Score: \(game.scoreKeeper.totalScore)"
    }
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, currentEmojiChoices.count > 0 {
            emoji[card] =  currentEmojiChoices.remove(at: currentEmojiChoices.count.arc4random)
        }
        
        return emoji[card] ?? "?"
    }
    
    private func updateUI(for theme: GameTheme){
        self.currentGameTheme = theme
        if let emojiChoices = self.currentGameTheme?.emojiChoices {
            self.currentEmojiChoices = emojiChoices
        }
        updateFlipCountLabel()
        self.view.backgroundColor = currentGameTheme?.backgroundColor
        scoreLabel.textColor = currentGameTheme?.cardBackFaceColor
        timerLabel.textColor = currentGameTheme?.cardBackFaceColor
        updateViewFromModel()
    }
    
    @objc private func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        var elapsedTime: TimeInterval = currentTime - startTime
        let minutes = UInt8(elapsedTime/60)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        timerLabel.text = "\(strMinutes):\(strSeconds)"
        
    }
    
    private func startTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


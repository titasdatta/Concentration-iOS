//
//  ThemeManager.swift
//  Concentration
//
//  Created by Titas Datta on 27/02/18.
//  Copyright © 2018 Titas Datta. All rights reserved.
//

import Foundation

class ThemeManager {
    
    let emojiChoicesHalloween = ["👻", "🎃", "🦇", "😱", "🙀", "👹", "😈", "🍭", "🐺"]
    let emojiChoicesAnimals = ["🐶", "🐱", "🐹", "🦊", "🐻", "🐼" ,"🐯" ,"🦁", "🐵"]
    let emojiChoicesSports = ["⚽️", "🏀", "🏈", "🎾", "🏹", "🏓", "🎱", "🏑", "🏸"]
    let emojiChoicesFaces = ["😀", "☺️", "🤪", "😘", "😞", "🤯", "🤔", "😡", "😎"]
    let emojiChoicesFood = ["🍏", "🍓", "🍆", "🥞", "🍐", "🍋", "🍇", "🥝", "🥕"]
    let emojiChoicesObjects = ["⌚️", "📷", "⏰", "🎥", "💻", "🔦", "⚒", "☎️", "🖨"]
    
    var gameThemes: [GameTheme] = []
    
    init() {
        gameThemes = [GameTheme(emojiChoices: emojiChoicesHalloween, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardBackFaceColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
                      GameTheme(emojiChoices: emojiChoicesAnimals, backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
                      GameTheme(emojiChoices: emojiChoicesObjects, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
                      GameTheme(emojiChoices: emojiChoicesFood, backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)),
                      GameTheme(emojiChoices: emojiChoicesFaces, backgroundColor: #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)),
                      GameTheme(emojiChoices: emojiChoicesSports, backgroundColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), cardBackFaceColor: #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))]
    }
    
    func chooseRandomGameTheme() -> GameTheme {
        let randomIndex = Int(arc4random_uniform(UInt32(gameThemes.count)))
        return gameThemes[randomIndex]
    }
}

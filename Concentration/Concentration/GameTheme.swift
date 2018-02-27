//
//  GameTheme.swift
//  Concentration
//
//  Created by Titas Datta on 27/02/18.
//  Copyright © 2018 Titas Datta. All rights reserved.
//

import Foundation
import UIKit

struct GameTheme {
    var emojiChoices: [String]
    var backgroundColor: UIColor
    var cardBackFaceColor: UIColor
    
    init(emojiChoices: [String], backgroundColor: UIColor, cardBackFaceColor: UIColor) {
        self.emojiChoices = emojiChoices
        self.backgroundColor = backgroundColor
        self.cardBackFaceColor = cardBackFaceColor
    }
}

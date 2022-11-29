//
//  checkAnswer.swift
//  xmasWordle
//
//  Created by shelley on 2022/11/24.
//

import Foundation
import UIKit

enum CheckAnswer {
    case correct, wrong, wrongsite, original
    
    var answerColor : UIColor {
        switch self{
        case .correct:
            return UIColor(red: 3/255, green: 79/255, blue: 27/255, alpha: 1)
        case .wrong:
            return UIColor(red: 126/255, green: 18/255, blue: 25/255, alpha: 1)
        case .wrongsite:
            return UIColor(red: 243/255, green: 188/255, blue: 46/255, alpha: 1)
        case .original:
            return UIColor(red: 132/255, green: 165/255, blue: 184/255, alpha: 1)
        }
    }
    
    var emoji: String {
        switch self {
        case.correct:
            return "🟩"
        case .wrong:
            return "🟥"
        case .wrongsite:
            return "🟨"
        case .original:
            return ""
        }
    }
}

//
//  File.swift
//  xmasWordle
//
//  Created by shelley on 2022/11/24.
//

import Foundation

// 建立題目
struct Question {
    let words = ["angel",
                 "bells",
                 "bough",
                 "candy",
                 "carol",
                 "cheer",
                 "claus",
                 "comet",
                 "crown",
                 "cupid",
                 "elves",
                 "fairy",
                 "frost",
                 "gifts",
                 "gnome",
                 "green",
                 "holly",
                 "merry",
                 "movie",
                 "myrrh",
                 "santa",
                 "scarf",
                 "snowy",
                 "vixen",
                 "white",
                 "jolly",
                 "glove"]
// 隨機取題
    func makeNewQuestion() -> String{
        let randomWord = words.randomElement()!
        return randomWord.uppercased()
    }
}

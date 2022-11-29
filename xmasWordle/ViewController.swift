//
//  ViewController.swift
//  xmasWordle
//
//  Created by shelley on 2022/11/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var lettersLable: [UILabel]!
    @IBOutlet var keyboardsBtn: [UIButton]!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var deletBtn: UIButton!
    
    @IBOutlet weak var gameInfoBtn: UIButton!
    @IBOutlet var gameInfoView: UIView!
    @IBOutlet weak var musicSlashBtn: UIButton!
    
// 輸入的字母排序
    var lettersLableIndex = -1
    
// 猜字、問題、emoji轉成字串
    var guessWords = [String]()
    var questionWords = [String]()
    var showEmoji = [String]()
// 產生題目
    var newQuestion = Question().makeNewQuestion()
    
    var looper: AVPlayerLooper?
    let player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playMusic()
    
    }
    func playMusic(){
        let xmasUrl = URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/e5/ed/99/e5ed99e2-50ed-b212-e615-4e18902fb95f/mzaf_5330769316725861860.plus.aac.p.m4a")
        let player = AVQueuePlayer()
        let playerItem = AVPlayerItem(url: xmasUrl!)
        looper = AVPlayerLooper(player: player, templateItem: playerItem)
        player.play()
    }

    @IBAction func stopMusic(_ sender: UIButton) {
        player.pause()
    }
    @IBAction func gameInfoView(_ sender: Any) {
        gameInfoView.isHidden = false
    }
    @IBAction func closeGameInfo(_ sender: Any) {
        gameInfoView.isHidden = true
    }
// 輸入字母，需輸入5個字母
    @IBAction func inputLetters(_ sender: UIButton) {
        lettersLableIndex += 1
        deletBtn.isEnabled = true
        let inputLable = lettersLableIndex % 5
        if inputLable == 4{
            keyboardEnable(bool: false)
        }
        lettersLable[lettersLableIndex].text = sender.configuration?.title
    }
    
// 按下確認鍵，比對五個字母與正確答案的關聯性，並同步顯示在鍵盤上
    @IBAction func enterWord(_ sender: UIButton) {
        let firstNum = lettersLableIndex - 4
        for words in newQuestion{
            questionWords.append(String(words))
        }
        lablesCheck(cards: lettersLable, num:firstNum )
        keyboardEnable(bool: true)
        let fiveLableCorrect = lettersLable[firstNum].backgroundColor == CheckAnswer.correct.answerColor && lettersLable[firstNum+1 ].backgroundColor == CheckAnswer.correct.answerColor && lettersLable[firstNum+2 ].backgroundColor == CheckAnswer.correct.answerColor && lettersLable[firstNum+3 ].backgroundColor == CheckAnswer.correct.answerColor && lettersLable[lettersLableIndex].backgroundColor == CheckAnswer.correct.answerColor
        if fiveLableCorrect{
            alert(title: "恭喜！", message: "\n" + showResultEmoji(rowNumber: lettersLableIndex, emojiArray: showEmoji), actionContent: "再玩一次")
            reStart()
        }else if lettersLableIndex == 29{
            alert(title: "答案是", message: "\(newQuestion)" + showResultEmoji(rowNumber: lettersLableIndex, emojiArray: showEmoji), actionContent: "再玩一次")
            reStart()
        }
    }
// 刪除字母
    @IBAction func deleteWord(_ sender: UIButton) {
        if lettersLableIndex % 5 != 0 {
            keyboardEnable(bool: true)
        }else{
            deletBtn.isEnabled = false
        }
        lettersLable[lettersLableIndex].text = ""
        lettersLableIndex -= 1
    }
    
    func keyboardEnable(bool:Bool){
        if bool != true{
            for i in 0..<keyboardsBtn.count{
                keyboardsBtn[i].isEnabled = false
            }
            enterBtn.isEnabled = true
        }else{
            for i in 0..<keyboardsBtn.count{
                keyboardsBtn[i].isEnabled = true
            }
            enterBtn.isEnabled = false
        }
    }
    
    func alert(title:String, message:String, actionContent:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: actionContent, style: .default, handler: nil)
        alertController.addAction(actionButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func reStart(){
        lettersLableIndex = -1
        newQuestion = Question().makeNewQuestion()
        guessWords = [String]()
        questionWords = [String]()
        showEmoji = [String]()
        for i in 0..<lettersLable.count {
            lettersLable[i].text = ""
            lettersLable[i].backgroundColor = CheckAnswer.original.answerColor
        }
        for j in 0..<keyboardsBtn.count {
            keyboardsBtn[j].configuration?.baseBackgroundColor = UIColor.lightGray
        }
        keyboardEnable(bool: true)
    }
// 利用方塊emoji顯示結果
    func showResultEmoji(rowNumber:Int, emojiArray: Array<String>) ->String{
        var emojiString = ""
        let endRow = rowNumber / 5 + 1
        for j in 1...endRow {
            for i in 1...5 {
                emojiString += emojiArray[j*5-(6-i)]
            }
            emojiString += "\n"
        }
        return emojiString
    }
    func keyboardCheck(array: Array<String>, index: Int, color: UIColor){
        for i in 0..<keyboardsBtn.count {
            let kbLetters = keyboardsBtn[i].configuration?.title!
            if kbLetters == array[index]{
                keyboardsBtn[i].configuration?.baseBackgroundColor = color
            }
        }
    }
    
    func lablesCheck(cards: Array<UILabel>, num: Int){
        for i in num...num+4{
            let letter = cards[i].text!
            self.guessWords.append(letter)
            if self.questionWords[i] == self.guessWords[i] {
                cards[i].backgroundColor = CheckAnswer.correct.answerColor
                showEmoji.append(CheckAnswer.correct.emoji)
                keyboardCheck(array: questionWords, index: i, color: CheckAnswer.correct.answerColor)
            }else if newQuestion.contains(letter){
                cards[i].backgroundColor = CheckAnswer.wrongsite.answerColor
                showEmoji.append(CheckAnswer.wrongsite.emoji)
                keyboardCheck(array: guessWords, index: i, color: CheckAnswer.wrongsite.answerColor)
            }else{
                cards[i].backgroundColor = CheckAnswer.wrong.answerColor
                showEmoji.append(CheckAnswer.wrong.emoji)
                keyboardCheck(array: guessWords, index: i, color: CheckAnswer.wrong.answerColor)
            }
        }
    }
    
}


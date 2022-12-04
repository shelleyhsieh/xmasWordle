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
    
// 輸入的字母排序,第幾個
    var lettersLableIndex = -1
// 輸入的按鈕數量
    var keyboardBtnNumber = [Int]()

// 猜字、問題、emoji轉成字串
    var guessWords = [String](repeating: "", count: 5)
    var questionWords = [String]()
    var showEmoji = [String]()
    
// 產生題目
    var newQuestion = Question().makeNewQuestion()
    
    
// 宣告AVPlayer，生成播音樂的物件
    let player = AVPlayer()
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBth: UIButton!
// 打開App即播放音樂，遊戲說明自行點選右上角符號，故一開始先隱藏遊戲說明
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playMusic()
        gameInfoView.isHidden = true
    }
// 播音樂，將音檔直接拉到project navigator,在呼叫url傳入檔名及副檔名，回傳的url是？可在後放加上！取值
// 利用 AVPlayerItem產生要播放的音樂
// 再利用 replaceCurrentItem 設定要播放的音樂
    func playMusic(){
        let xmasUrl = Bundle.main.url(forResource: "Jingle Bell Rock ", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: xmasUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
// 按下播音樂後，顯示禁音的圖示，有聲圖案則隱藏
    @IBAction func playMusic(_ sender: UIButton) {
        player.play()
        pauseBth.isHidden = true
        playBtn.isHidden = false
    }
// 停止播放音樂，顯示有聲圖案，禁音圖示則隱藏
    @IBAction func stopMusic(_ sender: UIButton) {
        player.pause()
        pauseBth.isHidden = false
        playBtn.isHidden = true
    }
// 遊戲說明的按鈕
    @IBAction func gameInfoView(_ sender: Any) {
        gameInfoView.isHidden = false
    }
    @IBAction func closeGameInfo(_ sender: Any) {
        gameInfoView.isHidden = true
    }
// 輸入字母，最多5個字母，打開刪除鍵
    @IBAction func inputLetters(_ sender: UIButton) {
//        var buttonIndex = 0
        lettersLableIndex += 1
        deletBtn.isEnabled = true
        let inputLable = lettersLableIndex % 5
//        while sender != keyboardsBtn[buttonIndex] {
//            buttonIndex += 1
//        }
//// 當輸入5個字母後，無法再輸入，鍵盤字母同步顯示到猜字卡上
//        if keyboardBtnNumber.count < 5 {
//            keyboardBtnNumber.append(buttonIndex)
//            if let kbTitle = keyboardsBtn[buttonIndex].configuration?.title{
//                guessWords[inputLable] = kbTitle
//                lettersLable[lettersLableIndex].text = guessWords[inputLable]
//
//                lettersLableIndex += 1
//            }
//        }
        
        if inputLable == 4{
            keyboardEnable(KB26: false)
        }
        lettersLable[lettersLableIndex].text = sender.configuration?.title
    }

// 按下確認鍵，比對五個字母與正確答案的關聯性，並同步顯示在鍵盤上
    @IBAction func enterWord(_ sender: UIButton) {
        let firstNum = lettersLableIndex - 4
        for words in newQuestion{
            questionWords.append(String(words))
        }
// 顯示卡牌顏色
        lablesColorCheck(cards: lettersLable, num: firstNum)
        keyboardEnable(KB26: true)
        let fiveLableCorrect = self.lettersLable[firstNum].backgroundColor == CheckAnswer.correct.answerColor && self.lettersLable[firstNum+1].backgroundColor == CheckAnswer.correct.answerColor && self.lettersLable[firstNum+2].backgroundColor == CheckAnswer.correct.answerColor && self.lettersLable[firstNum+3].backgroundColor == CheckAnswer.correct.answerColor && self.lettersLable[self.lettersLableIndex].backgroundColor == CheckAnswer.correct.answerColor
// 若猜對單字、猜完六次還是猜錯
        if fiveLableCorrect{
            alert(title: "恭喜！", message: "\n" + showResultEmoji(rowNumber: lettersLableIndex, emojiArray: showEmoji), actionContent: "再玩一次")
            reStart()
        }else if lettersLableIndex == 29{
            alert(title: "答案是", message: "\(newQuestion)\n" + showResultEmoji(rowNumber: lettersLableIndex, emojiArray: showEmoji), actionContent: "再玩一次")
            reStart()
        }
        deletBtn.isEnabled = false
// 輸入字量少於5個字時，按下enter則會出現警告，提示字數須達5個字
//        if keyboardsBtn.count < 4 {
//            alert(title: "字數太少囉！", message: "請輸滿5個字母", actionContent: "再猜一次")
//        }
//        lettersLable[lettersLableIndex].text = sender.configuration?.title
    }
// 刪除字母
    @IBAction func deleteWord(_ sender: UIButton) {
//        let inputLetterIndex = (lettersLableIndex-1) % 5
//        if keyboardBtnNumber.count > 0{
//            guessWords[inputLetterIndex] = ""
//
//            keyboardBtnNumber.removeLast()
//
//            lettersLableIndex -= 1
//            lettersLable[lettersLableIndex].text = ""
//        }
        
        if lettersLableIndex % 5 != 0 {
            keyboardEnable(KB26: true)
        }else{
            deletBtn.isEnabled = false
        }
        lettersLable[lettersLableIndex].text = ""
        lettersLableIndex -= 1
    }
    
    func keyboardEnable(KB26:Bool){
        if KB26 != true{
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

    
// 提示
    func alert(title:String, message:String, actionContent:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: actionContent, style: .default, handler: nil)
        alertController.addAction(actionButton)
        present(alertController, animated: true, completion: nil)
    }
// 遊戲重新開始
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
        keyboardEnable(KB26: true)
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
// 顯示輸入後對應的鍵盤顏色
    func keyboardCheck(array: Array<String>, index: Int, color: UIColor){
        for i in 0..<keyboardsBtn.count {
            let kbLetters = keyboardsBtn[i].configuration?.title!
            if kbLetters == array[index]{
                keyboardsBtn[i].configuration?.baseBackgroundColor = color
            }
        }
    }
// 卡牌顏色確認,前要加self 鍵盤才顯示得出顏色
    func lablesColorCheck(cards: Array<UILabel>, num: Int){
        for i in num...num+4{
            let letter = cards[i].text!
            self.guessWords.append(letter)
            if self.questionWords[i] == self.guessWords[i] {
                cards[i].backgroundColor = CheckAnswer.correct.answerColor
                self.showEmoji.append(CheckAnswer.correct.emoji)
                self.keyboardCheck(array: self.questionWords, index: i, color: CheckAnswer.correct.answerColor)
            }else if newQuestion.contains(letter){
                cards[i].backgroundColor = CheckAnswer.wrongsite.answerColor
                self.showEmoji.append(CheckAnswer.wrongsite.emoji)
                self.keyboardCheck(array: self.guessWords, index: i, color: CheckAnswer.wrongsite.answerColor)
            }else{
                cards[i].backgroundColor = CheckAnswer.wrong.answerColor
                self.showEmoji.append(CheckAnswer.wrong.emoji)
                self.keyboardCheck(array: self.guessWords, index: i, color: CheckAnswer.wrong.answerColor)
            }
        }
    }
    
    
}


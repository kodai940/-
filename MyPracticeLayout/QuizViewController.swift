//
//  QuizViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/07.
//

import UIKit
import RealmSwift
import AVFoundation
import GoogleMobileAds

class QuizViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var CountLabel: UILabel!

    @IBOutlet weak var QuestionLabel: UITextView!
    @IBOutlet weak var AnswerButton1: UIButton!
    @IBOutlet weak var AnswerButton2: UIButton!
    @IBOutlet weak var AnswerButton3: UIButton!
    @IBOutlet weak var AnswerButton4: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    
    
    let realm = try! Realm()
    let userDefaults:UserDefaults = UserDefaults.standard
    let defaultValues = ["wordCount": 10, "bgmCW": true, "bgmP": true, "speed": 0.005] as [String : Any]
    
    private let correctSound = try! AVAudioPlayer(data: NSDataAsset(name: "Correct_Answer")!.data)
    private let wrongSound = try! AVAudioPlayer(data: NSDataAsset(name: "Wrong_Answer")!.data)
    var audioPlayer: AVAudioPlayer!
    
    var quizTimer: Timer?
    
    var bannerView: GADBannerView!
    var csvArray: [String] = []
//    var dataArray: [String] = []
    
    var dataArray600: [String] = []
//    var dataArray700: [String] = []
//    var dataArray800: [String] = []
//    var dataArray900: [String] = []
    
    var dataShuffledArray: [String] = []
    var quizArray: [String] = []
    var quizCount: Int = 0
    var scoreCount: Int = 0
    var quizCorrectArray: [Int] = []
    
    var wrongNum: [Int] = []
    var correctNum: [Int] = []
    var csvWrongNum: Int = 0
    var csvCorrectNum: Int = 0
    
    var selectLevel: Int = 0
    var selectSection: Int = 0
    var listArray: [Int] = []
    var listKey: Bool = false
    var searchArray: [String] = []
    var searchShuffledArray: [String] = []
    
    var favoriteNum: [Int] = []
    var favoriteKey: Bool = false
    var favoriteArray: [String] = []
    var favoriteShuffledArray: [String] = []
    
    var nextShuffledArray: [String] = []
    
    var scoreListArray: [String] = []
    
    
    //スコア画面処理
    var quizContinued: Bool = false

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonDesign()
        
        userDefaults.register(defaults: defaultValues)
        
        dataArray600 = loadCSV(fileName: "TOEIC600")
//        dataArray700 = loadCSV(fileName: "TOEIC700")
//        dataArray800 = loadCSV(fileName: "TOEIC800")
//        dataArray900 = loadCSV(fileName: "TOEIC900")
        
        csvArray = dataArray600
        
        let wrongResults = realm.objects(WrongNumberTOEIC.self)
        let correctResults = realm.objects(CorrectNumberTOEIC.self)
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        //間違えた問題番号を配列に入れる
        for i in 0 ..< wrongResults.count {
            wrongNum.append(wrongResults[i].wrongNumberToeic)
        }
        
        //正解した問題番号を配列に入れる
        for i in 0 ..< correctResults.count {
            correctNum.append(correctResults[i].correctNumberToeic)
        }
        
        //しぼりこみ検索から出題
        if listKey {
            print("listArray\(listArray)")
            for i in 0 ..< listArray.count {
                let x = listArray[i]
                searchArray.append(csvArray[x])
            }
            print("searchArray\(searchArray)")
            searchShuffledArray = searchArray.shuffled()
            setQuiz(shuffledArray: &searchShuffledArray)
        } else {
            for i in 0 ..< favoriteNum.count {
                let x = favoriteNum[i]
                favoriteArray.append(csvArray[x])
            }
            favoriteShuffledArray = favoriteArray.shuffled()
            setQuiz(shuffledArray: &favoriteShuffledArray)
        }
        
//        else {
//            dataShuffledArray = dataArray.shuffled()
//            setQuiz(shuffledArray: &dataShuffledArray)
//        }
    }
    
    func setQuiz(shuffledArray: inout [String]) {
        let wordCount = UserDefaults.standard.integer(forKey: "wordCount")
        let timeInterval = UserDefaults.standard.double(forKey: "speed")
        let bgmPSetting = UserDefaults.standard.bool(forKey: "bgmP")
        
        var maxCount = 0
        
        scoreListArray.append(shuffledArray[quizCount])
        quizArray = shuffledArray[quizCount].components(separatedBy: ",")
        print("shuffledArray\(shuffledArray)")
        print("quizArray\(quizArray)")
        
        if wordCount > shuffledArray.count {
            maxCount = shuffledArray.count
        } else {
            maxCount = wordCount
        }

        
        guard let audioPath = Bundle.main.path(forResource: "\(quizArray[0])", ofType: "mp3", inDirectory: nil) else {
            print("file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            audioPlayer.delegate = self
        } catch {
            print("audioFailed")
        }

//        //音声ファイルを再生する
        if bgmPSetting {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        
        CountLabel.text = "\(quizCount + 1) / \(maxCount)"
        QuestionLabel.text = quizArray[0]
        
        let answerIntArray = [2, 3, 4, 5]
        let answerShuffledArray = answerIntArray.shuffled()
        
        AnswerButton1.setTitle(quizArray[answerShuffledArray[0]], for: .normal)
        AnswerButton2.setTitle(quizArray[answerShuffledArray[1]], for: .normal)
        AnswerButton3.setTitle(quizArray[answerShuffledArray[2]], for: .normal)
        AnswerButton4.setTitle(quizArray[answerShuffledArray[3]], for: .normal)
        
        ProgressBar.progress = 1.0
        //timeInterval 制限時間の速さ
        quizTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timeF), userInfo: nil, repeats: true)
    }
    
    func nextQuiz(shuffledArray: inout [String]) {
        let wordCount = UserDefaults.standard.integer(forKey: "wordCount")
        let timeInterVal = UserDefaults.standard.double(forKey: "speed")
        let bgmPSetting = UserDefaults.standard.bool(forKey: "bgmP")
        
        var maxCount = 0
        
        quizCount += 1
        
        if wordCount > shuffledArray.count {
            maxCount = shuffledArray.count
        } else {
            maxCount = wordCount
        }

        if quizCount < maxCount {
            scoreListArray.append(shuffledArray[quizCount])
            quizArray = shuffledArray[quizCount].components(separatedBy: ",")
            CountLabel.text = "\(quizCount + 1) / \(maxCount)"
            QuestionLabel.text = quizArray[0]
            
            let answerIntArray = [2, 3, 4, 5]
            let answerShuffledArray = answerIntArray.shuffled()
            
            AnswerButton1.setTitle(quizArray[answerShuffledArray[0]], for: .normal)
            AnswerButton2.setTitle(quizArray[answerShuffledArray[1]], for: .normal)
            AnswerButton3.setTitle(quizArray[answerShuffledArray[2]], for: .normal)
            AnswerButton4.setTitle(quizArray[answerShuffledArray[3]], for: .normal)
            
            guard let audioPath = Bundle.main.path(forResource: "\(quizArray[0])", ofType: "mp3", inDirectory: nil) else {
                print("file not found")
                return
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
                audioPlayer.delegate = self
            } catch {
                print("audioFailed")
            }
            
            //音声ファイルを再生する
            if bgmPSetting {
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            
            ProgressBar.progress = 1.0
            quizTimer = Timer.scheduledTimer(timeInterval: timeInterVal, target: self, selector: #selector(timeF), userInfo: nil, repeats: true)
            
        } else {
            //スコア画面処理
            shuffledArray.removeFirst(quizCount)

            let shuffledArrayCount = shuffledArray.count
            nextShuffledArray = shuffledArray
            
            let storyboard = self.storyboard!
            let scoreVC = storyboard.instantiateViewController(withIdentifier: "scoreViewController") as! ScoreViewController
            scoreVC.count = scoreCount
            scoreVC.listArray = scoreListArray
            scoreVC.correctArray = quizCorrectArray
            scoreVC.nextQuizCount = shuffledArrayCount
            scoreVC.presentationController?.delegate = self
            let nav = UINavigationController(rootViewController: scoreVC)
            nav.modalPresentationStyle = .fullScreen
            nav.navigationBar.barTintColor = .systemGray6
            nav.presentationController?.delegate = self
            //スコア画面処理
            self.present(nav, animated: true, completion: nil)
        }
    }

    @objc func timeF() {
        let newValue = ProgressBar.progress - 0.001
        
        if newValue < 0 {
            ProgressBar.progress = 0
            quizTimer!.invalidate()
            var correctNumber = Int(quizArray[1])
            correctNumber! += 1
            if AnswerButton1.currentTitle == quizArray[correctNumber!] {
                AnswerButton1.setTitleColor(.red, for:.normal)
                AnswerButton1.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            if AnswerButton2.currentTitle == quizArray[correctNumber!] {
                AnswerButton2.setTitleColor(.red, for:.normal)
                AnswerButton2.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            if AnswerButton3.currentTitle == quizArray[correctNumber!] {
                AnswerButton3.setTitleColor(.red, for:.normal)
                AnswerButton3.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            if AnswerButton4.currentTitle == quizArray[correctNumber!] {
                AnswerButton4.setTitleColor(.red, for:.normal)
                AnswerButton4.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            print("不正解")

            let bgmCWSetting = UserDefaults.standard.bool(forKey: "bgmCW")
            if bgmCWSetting {
                wrongSound.currentTime = 0
                wrongSound.play()
            }

            ImageView.image = UIImage(named: "incorrectMark")

            let csvQuiz = quizArray.joined(separator: ",")
             //不正解の場合、もしrealmのNumberDataW1に番号がない場合、番号を保存
            for i in 0 ..< csvArray.count{
                if csvArray[i] == csvQuiz {
                    if wrongNum.contains(i) {
                        break
                    } else {
                        csvWrongNum = i
                        print(csvWrongNum)
                        //**realm
                        saveWrongNumber(csvNumber: csvWrongNum)
                        break
                    }
                }
            }
            //不正解の場合、もしrealmのNumberDataC1に番号がある場合、番号を削除
            for i in 0 ..< csvArray.count{
                if csvArray[i] == csvQuiz {
                    if correctNum.contains(i) {
                        csvCorrectNum = i
                        print(csvCorrectNum)
                        deleteCorrectNumber(csvNumber: csvCorrectNum)
                        break
                    }
                }
            }
            ImageView.isHidden = false
            AnswerButton1.isEnabled = false
            AnswerButton2.isEnabled = false
            AnswerButton3.isEnabled = false
            AnswerButton4.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.ImageView.isHidden = true
                self.AnswerButton1.isEnabled = true
                self.AnswerButton2.isEnabled = true
                self.AnswerButton3.isEnabled = true
                self.AnswerButton4.isEnabled = true
                //正解ボタンの強調表示を解除
                self.AnswerButton1.setTitleColor(.black, for:.normal)
                self.AnswerButton2.setTitleColor(.black, for:.normal)
                self.AnswerButton3.setTitleColor(.black, for:.normal)
                self.AnswerButton4.setTitleColor(.black, for:.normal)
                self.AnswerButton1.backgroundColor = .systemGray6
                self.AnswerButton2.backgroundColor = .systemGray6
                self.AnswerButton3.backgroundColor = .systemGray6
                self.AnswerButton4.backgroundColor = .systemGray6
                if self.listKey {
                    self.nextQuiz(shuffledArray: &self.searchShuffledArray)
                } else {
                    self.nextQuiz(shuffledArray: &self.favoriteShuffledArray)
                }
                
//                else {
//                    self.nextQuiz(shuffledArray: &self.dataShuffledArray)
//                }
            }
        } else {
            ProgressBar.progress = newValue
        }
    }
    
    func saveWrongNumber(csvNumber: Int) {
        do {
            let wrongNumber: WrongNumberTOEIC = WrongNumberTOEIC(value: ["wrongNumberToeic" : csvNumber])
            try realm.write {
                realm.add(wrongNumber)
            }
        } catch {
            print("error\(error)")
        }
    }
    
    func saveCorrectNumber(csvNumber: Int) {
        do {
            let correctNumber: CorrectNumberTOEIC = CorrectNumberTOEIC(value: ["correctNumberToeic" : csvNumber])
            try realm.write {
                realm.add(correctNumber)
            }
        } catch {
            print("error\(error)")
        }
    }
    
    func deleteWrongNumber(csvNumber: Int) {
        let targetNumber = realm.objects(WrongNumberTOEIC.self).filter("wrongNumberToeic == \(csvNumber)")
        do {
            try realm.write {
                realm.delete(targetNumber)
            }
        } catch {
            print("error\(error)")
        }
    }
    
    func deleteCorrectNumber(csvNumber: Int) {
        let targetNumber = realm.objects(CorrectNumberTOEIC.self).filter("correctNumberToeic == \(csvNumber)")
        do {
            try realm.write{
                realm.delete(targetNumber)
            }
        } catch {
            print("error\(error)")
        }
    }
    
    @IBAction func btnAction(sender: UIButton) {
        quizTimer!.invalidate()
        AnswerButton1.isEnabled = false
        AnswerButton2.isEnabled = false
        AnswerButton3.isEnabled = false
        AnswerButton4.isEnabled = false
        
        var correctNumber = Int(quizArray[1])
        correctNumber! += 1
        
        let bgmCWSetting = UserDefaults.standard.bool(forKey: "bgmCW")
        
        if sender.currentTitle == quizArray[correctNumber!] {
            scoreCount += 1
            quizCorrectArray.append(quizCount)
            print("正解")
            
            if bgmCWSetting {
                correctSound.currentTime = 0
                correctSound.play()
            }
            ImageView.image = UIImage(named: "correctMark")

            sender.setTitleColor(UIColor(red: 64/255, green: 136/255, blue: 37/255, alpha: 1.0), for:.normal)
            sender.backgroundColor = UIColor(red: 195/255, green: 255/255, blue: 181/255, alpha: 1.0)
            
            //正解の場合、もしrealmのNumberDataW1に番号がある場合、番号を削除
            let csvQuiz = quizArray.joined(separator: ",")
            for i in 0 ..< csvArray.count{
                if csvArray[i] == csvQuiz {
                    if wrongNum.contains(i) {
                        csvWrongNum = i
                        print(csvWrongNum)
                        deleteWrongNumber(csvNumber: csvWrongNum)
                        break
                    }
                }
            }
            //正解の場合、もしrealmのNumberDataC1に番号がない場合、番号を保存
            for i in 0 ..< csvArray.count{
                if csvArray[i] == csvQuiz {
                    if correctNum.contains(i) {
                        break
                    } else {
                        csvCorrectNum = i
                        print(csvCorrectNum)
                        saveCorrectNumber(csvNumber: csvCorrectNum)
                        break
                    }
                }
            }
        //elseの場合、答えの選択肢を強調する、
        } else {
            if AnswerButton1.currentTitle == quizArray[correctNumber!] {
                AnswerButton1.setTitleColor(.red, for:.normal)
                AnswerButton1.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            if AnswerButton2.currentTitle == quizArray[correctNumber!] {
                AnswerButton2.setTitleColor(.red, for:.normal)
                AnswerButton2.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            if AnswerButton3.currentTitle == quizArray[correctNumber!] {
                AnswerButton3.setTitleColor(.red, for:.normal)
                AnswerButton3.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            if AnswerButton4.currentTitle == quizArray[correctNumber!] {
                AnswerButton4.setTitleColor(.red, for:.normal)
                AnswerButton4.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 211/255, alpha: 1.0)
            }
            print("不正解")
            
            if bgmCWSetting {
                wrongSound.currentTime = 0
                wrongSound.play()
            }
            ImageView.image = UIImage(named: "incorrectMark")
            
            let csvQuiz = quizArray.joined(separator: ",")
            //不正解の場合、もしrealmのNumberDataW1に番号がない場合、番号を保存
            for i in 0 ..< csvArray.count{
                if csvArray[i] == csvQuiz {
                    if wrongNum.contains(i) {
                        break
                    } else {
                        csvWrongNum = i
                        print(csvWrongNum)
                        //**realm
                        saveWrongNumber(csvNumber: csvWrongNum)
                        break
                    }
                }
            }
            //不正解の場合、もしrealmのNumberDataC1に番号がある場合、番号を削除
            for i in 0 ..< csvArray.count{
                if csvArray[i] == csvQuiz {
                    if correctNum.contains(i) {
                        csvCorrectNum = i
                        print(csvCorrectNum)
                        deleteCorrectNumber(csvNumber: csvCorrectNum)
                        break
                    }
                }
            }
        }
        ImageView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //正解ボタンの強調表示を解除
            self.AnswerButton1.setTitleColor(.black, for:.normal)
            self.AnswerButton2.setTitleColor(.black, for:.normal)
            self.AnswerButton3.setTitleColor(.black, for:.normal)
            self.AnswerButton4.setTitleColor(.black, for:.normal)
            self.AnswerButton1.backgroundColor = .systemGray6
            self.AnswerButton2.backgroundColor = .systemGray6
            self.AnswerButton3.backgroundColor = .systemGray6
            self.AnswerButton4.backgroundColor = .systemGray6
            self.ImageView.isHidden = true
            self.AnswerButton1.isEnabled = true
            self.AnswerButton2.isEnabled = true
            self.AnswerButton3.isEnabled = true
            self.AnswerButton4.isEnabled = true
            if self.listKey {
                self.nextQuiz(shuffledArray: &self.searchShuffledArray)
            } else {
                self.nextQuiz(shuffledArray: &self.favoriteShuffledArray)
            }
            
//            else {
//                self.nextQuiz(shuffledArray: &self.dataShuffledArray)
//            }
        }
    }
    
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
        let csvData = try String(contentsOfFile: csvBundle,encoding: String.Encoding.utf8)
        let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
        csvArray = lineChange.components(separatedBy: "\n")
        csvArray.removeLast()
        } catch {
        print("エラー")
        }
        return csvArray
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                        attribute: .bottom,
                        relatedBy: .equal,
                        toItem: view.safeAreaLayoutGuide,
                        attribute: .bottom,
                        multiplier: 1,
                        constant: 0),
             NSLayoutConstraint(item: bannerView,
                        attribute: .centerX,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .centerX,
                        multiplier: 1,
                        constant: 0)
            ])
    }
}

extension QuizViewController {
    func buttonDesign() {
        AnswerButton1.layer.borderWidth = 0.8
        AnswerButton2.layer.borderWidth = 0.8
        AnswerButton3.layer.borderWidth = 0.8
        AnswerButton4.layer.borderWidth = 0.8
        AnswerButton1.layer.borderColor = UIColor.systemGray6.cgColor
        AnswerButton2.layer.borderColor = UIColor.systemGray6.cgColor
        AnswerButton3.layer.borderColor = UIColor.systemGray6.cgColor
        AnswerButton4.layer.borderColor = UIColor.systemGray6.cgColor
        AnswerButton1.layer.cornerRadius = 10
        AnswerButton2.layer.cornerRadius = 10
        AnswerButton3.layer.cornerRadius = 10
        AnswerButton4.layer.cornerRadius = 10
    }
}

extension QuizViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("dismiss")
        scoreListArray = []
        quizCorrectArray = []
        quizCount = 0
        scoreCount = 0
        setQuiz(shuffledArray: &nextShuffledArray)
    }
}

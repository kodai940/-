//
//  SearchViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/05.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var MyTableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    //wordData読み込み用の配列
    var wordDatas: [WordData] = []
    //絞り込み後のデータ用の配列
    var filteredWords: [WordData] = []
    
    //検索後のデータ用の配列
    var searchResults: [WordData] = []
    
    //csvファイルを読み込む配列
    var csvArray: [String] = []
    
    var dataArray0_0: [String] = []
    var dataArray0_1: [String] = []
    var dataArray0_2: [String] = []
    var dataArray1_0: [String] = []
    
    //誤答・正答番号をRealmから読み込む
    var wrongArray: [Int] = []
    var correctArray: [Int] = []
    
    //データをtableViewに出力するための配列
    var quizArray: [String] = []
    var elementArray: [String] = []
    var wordList: String = ""
    
    var levelArray: [String] = []
    var referenceArray: [String] = []
    var typeArray: [String] = []
    var wcArray: [String] = []
    var tagArray: [String] = []

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray0_0 = loadCSV(fileName: "quiz0_0")
        dataArray0_1 = loadCSV(fileName: "quiz0_1")
        dataArray0_2 = loadCSV(fileName: "quiz0_2")
        dataArray1_0 = loadCSV(fileName: "quiz1_0")
        
        csvArray = dataArray0_0 + dataArray0_1 + dataArray0_2 + dataArray1_0

        let wrongResults = realm.objects(WrongNumberTOEIC.self)
        let correctResults = realm.objects(CorrectNumberTOEIC.self)
        
        for i in 0 ..< wrongResults.count {
            wrongArray.append(wrongResults[i].wrongNumberToeic)
        }
        
        for i in 0 ..< correctResults.count {
            correctArray.append(correctResults[i].correctNumberToeic)
        }
        
        for i in 0 ..< csvArray.count {
            quizArray = csvArray[i].components(separatedBy: ",")
            elementArray = csvArray[i].components(separatedBy: ",")
            quizArray.removeSubrange(1..<8)
            wordList = quizArray.joined(separator: ",")
            referenceArray.append(wordList)
            levelArray.append(elementArray[6])
            typeArray.append(elementArray[7])
        }
        
        //tagArrayにデータを格納
        
        
        //wcArrayにデータを格納
        for i in 0 ..< csvArray.count {
            if wrongArray.contains(i) {
                wcArray.append("間違えた単語")
            } else if correctArray.contains(i) {
                wcArray.append("正解した単語")
            } else {
                wcArray.append("未回答")
            }
        }
        
        MyTableView.delegate = self
        MyTableView.dataSource = self
        SearchBar.delegate = self
        MyTableView.tableFooterView = UIView()
        
        SearchBar.autocapitalizationType = .none
        
        loadData()
    }
    
    func loadData() {
        for i in 0 ..< csvArray.count {
            wordDatas.append(WordData(word: referenceArray[i], leveltype: "\(levelArray[i]) \(typeArray[i])", wc: wcArray[i], tag: ""))
        }
        filteredWords = wordDatas
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SearchBar.text != "" {
            return searchResults.count
        } else {
            return filteredWords.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        
        //QuizLabel LevelLabel TypeLabel オートレイアウト
        if SearchBar.text != "" {
            cell.WordLabel?.text = searchResults[indexPath.row].word
            cell.LevelTypeLabel?.text = searchResults[indexPath.row].leveltype
        } else {
            cell.WordLabel?.text = filteredWords[indexPath.row].word
            cell.LevelTypeLabel?.text = filteredWords[indexPath.row].leveltype
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let keyword = SearchBar.text, !keyword.isEmpty {
            searchResults = filteredWords.filter { $0.word.contains(keyword) }
        } else {
            searchResults = []
        }
        MyTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.text = ""
        SearchBar.endEditing(true)
        MyTableView.reloadData()
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
}

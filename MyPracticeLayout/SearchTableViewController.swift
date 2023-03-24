//
//  SearchTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/21.
//

import UIKit
import RealmSwift

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var MySearchBar: UISearchBar!
    @IBOutlet weak var MyTableView: UITableView!
    
    
    //wordData読み込み用の配列
    var wordDatas: [WordData] = []
    //絞り込み後のデータ用の配列
    var filteredWords: [WordData] = []
    
    //検索後のデータ用の配列
    var searchResults: [WordData] = []
    
    //csvファイルを読み込む配列
    var csvArray: [String] = []
    
    //誤答・正答番号をRealmから読み込む
    var wrongArray: [Int] = []
    var correctArray: [Int] = []
    
    //データをtableViewに出力するための配列
    var quizArray: [String] = []
    var elementArray: [String] = []
    var wordList: String = ""
    
    //検索結果の問題番号を取得
    var filterArray: [Int] = []
    var searchArray: [Int] = []
    var numberArray: [Int] = []
    
    var levelArray: [String] = []
    var referenceArray: [String] = []
    var typeArray: [String] = []
    var wcArray: [String] = []
    var tagArray: [String] = []

    //ユーザーが選ぶ
    var selectedWC: [String] = []
    var selectedLevel: [String] = []
    var selectedType: [String] = []
    var selectedTag: [String] = []
    
    var searchString: String = ""
    
    var headerTitle: [String] = []

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileNames = ["TOEIC600"]
        //let fileNames = ["TOEIC600","TOEIC700","TOEIC800","TOEIC900"]
        
        csvArray = fileNames.flatMap { loadCSV(fileName: $0) }
        
        print("csvArray\(csvArray.count)")

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
            quizArray.removeSubrange(1..<9)
            wordList = quizArray.joined(separator: ",")
            referenceArray.append(wordList)
            levelArray.append(elementArray[6])
            typeArray.append(elementArray[7])
            tagArray.append(elementArray[8])
        }
        
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
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "text.badge.star"), style: .plain, target: self, action: #selector(filterBarButtonTapped(_:)))
        filterButton.tintColor = .systemOrange
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(setButtonTapped(_:)))
        settingButton.tintColor = .systemOrange
        self.navigationItem.leftBarButtonItems = [filterButton, settingButton]
        
        let quizButton = UIBarButtonItem(title: "単語テスト", style: .done, target: self, action: #selector(quizBarButtonTapped(_:)))
        quizButton.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = quizButton
        
        MyTableView.delegate = self
        MyTableView.dataSource = self
        MySearchBar.delegate = self
        MyTableView.tableFooterView = UIView()
        
        MySearchBar.autocapitalizationType = .none
        
        loadData()
    }
    
    @objc func filterBarButtonTapped(_ sender: Any) {
        
        let filterView = self.storyboard?.instantiateViewController(withIdentifier: "filterTableVIew") as! FilterViewController

        filterView.presentationController?.delegate = self
        let nav = UINavigationController(rootViewController: filterView)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func setButtonTapped(_ sender: Any?) {
        print("設定")
        let settingView = self.storyboard?.instantiateViewController(withIdentifier: "settingView") as! SettingTableViewController
        settingView.presentationController?.delegate = self
        let nav = UINavigationController(rootViewController: settingView)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func quizBarButtonTapped(_ sender: Any) {
        if MySearchBar.text != "" {
            numberArray = searchArray
        } else {
            numberArray = filterArray
        }
        let quizVC = self.storyboard?.instantiateViewController(withIdentifier: "quizViewController") as! QuizViewController

        quizVC.listArray = numberArray
        quizVC.listKey = true
        quizVC.modalPresentationStyle = .fullScreen
        self.present(quizVC, animated: true, completion: nil)
    }
    
    func loadData() {
        
        print("loadData")
        for i in 0 ..< csvArray.count {
            wordDatas.append(WordData(word: referenceArray[i], level: levelArray[i], type: typeArray[i], wc: wcArray[i], tag: tagArray[i]))
        }
        
        filteredWords = wordDatas
        
        if selectedLevel.count > 0 {
            filteredWords = filteredWords.filter { selectedLevel.contains($0.level) }
        }
        
        if selectedType.count > 0 {
            filteredWords = filteredWords.filter { selectedType.contains($0.type) }
        }
        
        if selectedWC.count > 0 {
            filteredWords = filteredWords.filter { selectedWC.contains($0.wc) }
        }
        
        if selectedTag.count > 0 {
            filteredWords = filteredWords.filter { selectedTag.contains($0.tag) }
        }
        
        if selectedTag.contains("間違えやすい単語") {
            filteredWords = filteredWords.sorted { $0.word < $1.word }
        }
        
        headerTitle = selectedLevel + selectedType + selectedWC + selectedTag
        
        print("filteredWords: \(filteredWords)")
        
        for i in 0 ..< filteredWords.count {
            searchString = filteredWords[i].word
            for i in 0 ..< referenceArray.count {
                if searchString == referenceArray[i] {
                    if !filterArray.contains(i) {
                        filterArray.append(i)
                    }
                }
            }
            print(filterArray)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        headerView.backgroundColor = .systemOrange
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let titleSize = label.sizeThatFits(CGSize(width: tableView.bounds.width - 32, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(x: 16, y: 0, width: titleSize.width, height: titleSize.height + 12)
        headerView.addSubview(label)
        
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let titleSize = label.sizeThatFits(CGSize(width: tableView.bounds.width - 32, height: CGFloat.greatestFiniteMagnitude))

        return titleSize.height + 12
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if headerTitle.count == 0 {
            return "しぼりこみ: 全て(\(filteredWords.count))"
        } else {
            return "しぼりこみ: \(headerTitle.joined(separator: ","))" + "(\(filteredWords.count))"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MySearchBar.text != "" {
            return searchResults.count
        } else {
            return filteredWords.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        
        //QuizLabel LevelLabel TypeLabel オートレイアウト
        if MySearchBar.text != "" {
            cell.WordLabel?.text = searchResults[indexPath.row].word
            cell.LevelTypeLabel?.text = "\(searchResults[indexPath.row].level) \(searchResults[indexPath.row].type)"
        } else {
            cell.WordLabel?.text = filteredWords[indexPath.row].word
            cell.LevelTypeLabel?.text = "\(filteredWords[indexPath.row].level) \(filteredWords[indexPath.row].type)"
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let keyword = MySearchBar.text, !keyword.isEmpty {
            searchResults = filteredWords.filter { $0.word.contains(keyword) }
        } else {
            searchResults = []
        }
        searchArray = []
        
        for i in 0 ..< searchResults.count {
            searchString = searchResults[i].word
            for i in 0 ..< referenceArray.count {
                if searchString == referenceArray[i] {
                    if !searchArray.contains(i) {
                        searchArray.append(i)
                    }
                }
            }
        }
        
        if let quizButton = navigationItem.rightBarButtonItem {
            if filteredWords.count == 0 && searchResults.count == 0 {
                quizButton.isEnabled = false
            } else {
                quizButton.isEnabled = true
            }
        }
        print(searchArray)
        MyTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        MySearchBar.text = ""
        MySearchBar.endEditing(true)
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

extension SearchTableViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        wordDatas = []
        filterArray = []
        MySearchBar.text = ""
        loadData()
        MyTableView.reloadData()


        //モーダルdismiss時にクイズボタンの有効/無効を切り替える
        if let quizButton = navigationItem.rightBarButtonItem {
            if filteredWords.count == 0 && searchResults.count == 0 {
                quizButton.isEnabled = false
            } else {
                quizButton.isEnabled = true
            }
        }
    }
}

//
//  CountTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/03/20.
//

import UIKit
import RealmSwift

class CountTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var MyTableView: UITableView!
    
    var csvArray: [String] = []
    var dataArray600: [String] = []
    
    var sectionTitle: [String] = []
    var cellTitle = [[String]]()
    
    var totalCountArray = [[Int]]()
    var correctCounts: [[String: Int]]  = [[:]]
    
    var correctNum: [Int] = []
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyTableView.delegate = self
        MyTableView.dataSource = self
    }
    
    func loadData() {
        
        print("loadData")
        dataArray600 = loadCSV(fileName: "TOEIC600")
        csvArray = dataArray600
        
        sectionTitle = ["品詞","レベル別","ビジネス関連","さらに絞りこむ"]
        
        for _ in 0 ... 3 {
            cellTitle.append([])
            totalCountArray.append([])
        }
        
        cellTitle[0] = ["名詞","動詞","形容詞","副詞","熟語"]
        cellTitle[1] = ["TOEIC600点レベル","TOEIC700点レベル","TOEIC800点レベル","TOEIC900点レベル"]
        cellTitle[2] = ["住宅・不動産","商取引・販売","運送・納品","広告・宣伝","流行・普及","損害賠償・保険","企業形態・企業関連","雇用・求人募集","給料・手当","連絡(手紙・メール・電話)","財務・会計","裁判・法律","会議・議論","報道・出版","職業名","役職・部署","事務用品・日常用品","値段・料金"]
        cellTitle[3] = ["数量表現","位置・配置に関する表現","時間・頻度に関する表現","学問名","間違えやすい単語"]
        
        
        let correctResults = realm.objects(CorrectNumberTOEIC.self)
        
        for i in 0 ..< correctResults.count {
            correctNum.append(correctResults[i].correctNumberToeic)
        }

        print(correctNum)
        
        correctCounts = [
            ["名詞": 0,
             "動詞": 0,
             "形容詞": 0,
             "熟語": 0,
             "副詞": 0],
            ["TOEIC600点レベル": 0,
             "TOEIC700点レベル": 0,
             "TOEIC800点レベル": 0,
             "TOEIC900点レベル": 0],
            ["住宅・不動産": 0,
             "商取引・販売": 0,
             "運送・納品": 0,
             "広告・宣伝": 0,
             "流行・普及": 0,
             "損害賠償・保険": 0,
             "企業形態・企業関連": 0,
             "雇用・求人募集": 0,
             "給料・手当": 0,
             "連絡(手紙・メール・電話)": 0,
             "財務・会計": 0,
             "裁判・法律": 0,
             "会議・議論": 0,
             "報道・出版": 0,
             "職業名": 0,
             "役職・部署": 0,
             "事務用品・日常用品": 0,
             "値段・料金": 0],
            ["数量表現": 0,
             "位置・配置に関する表現": 0,
             "時間・頻度に関する表現": 0,
             "学問名": 0,
             "間違えやすい単語": 0]
        ]
        
        for element in csvArray {
            for (i, dict) in correctCounts.enumerated() {
                for (key, _) in dict {
                    if element.contains(key) && correctNum.contains(csvArray.firstIndex(of: element)!) {
                        correctCounts[i][key]? += 1 // 安全なオプショナルチェイン
                    }
                }
            }
        }

        for i in 0..<cellTitle.count {
            for title in cellTitle[i] {
                let totalCount = csvArray.filter { $0.contains(title) }.count
                totalCountArray[i].append(totalCount)
            }
        }
        
        print(correctCounts)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountTableViewCell
        
        cell.isUserInteractionEnabled = false
        
        cell.CategoryLabel?.text = cellTitle[indexPath.section][indexPath.row]
        cell.CountLabel?.text = "\(correctCounts[indexPath.section][cellTitle[indexPath.section][indexPath.row]] ?? 0) / \(totalCountArray[indexPath.section][indexPath.row])"
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        // 背景色を変更する
        view.tintColor = .systemOrange
        // テキストの色を変更する
        header.textLabel?.textColor = .white
        
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        correctNum = []
        correctCounts = [[:]]
        totalCountArray = [[]]
        loadData()
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

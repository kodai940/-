//
//  LevelTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/02.
//

import UIKit
import RealmSwift

class LevelTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var MyTableView: UITableView!
    
    var categoryNumber = 0
    var csvArray: [String] = []
    var cellTitleCount: Int = 0
    
    var dataArray: [String] = []
    var correctArray: [Int] = []
    var totalCount: Float = 0.0
    var dataCount: Int = 0
    
//    var correctFloatArray: [Float] = []
//    var totalFloatArray: [Float] = []
    var correctFloatArray = [[Float]]()
    var totalFloatArray = [[Float]]()
    
    var sectionTitle: [String] = []
    var cellTitle = [[String]]()

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        MyTableView.delegate = self
        MyTableView.dataSource = self
    }
    
    func loadData() {
        sectionTitle = ["TOEIC 400点レベル", "TOEIC 500点レベル"]  //"TOEIC 600点レベル", "TOEIC 700点レベル", "TOEIC 800点レベル"
        
        for _ in 0 ... 1 {
            cellTitle.append([])
            correctFloatArray.append([])
            totalFloatArray.append([])
        }
        
        cellTitle[0] = ["レベル1","レベル2","レベル3"]
        cellTitle[1] = ["レベル4"]  //"レベル5","レベル6"
//        cellTitle[2] = ["レベル7","レベル8","レベル9"]
//        cellTitle[3] = ["レベル10","レベル11","レベル12"]
//        cellTitle[4] = ["レベル13","レベル14","レベル15"]
//        cellTitle[5] = ["レベル16","レベル17","レベル18","レベル19","レベル20"]
        
        cellTitleCount = cellTitle[0].count + cellTitle[1].count
//        + cellTitle[2].count + cellTitle[3].count + cellTitle[4].count + cellTitle[5].count
        
        let results = realm.objects(CorrectNumberTOEIC.self)
        print(results)
        
        for i in 0 ..< results.count {
            correctArray.append(results[i].correctNumberToeic)
            print(correctArray)
        }
        print("correctArray: \(correctArray)")
        
        correctFloatArray[0].append(Float(correctArray.filter { $0 < 101 }.count))
        correctFloatArray[0].append(Float(correctArray.filter { $0 > 100 && $0 < 201 }.count))
        correctFloatArray[0].append(Float(correctArray.filter { $0 > 200 && $0 < 301 }.count))
        correctFloatArray[1].append(Float(correctArray.filter { $0 > 300 && $0 < 401 }.count))
        
        print("correctFloatArray: \(correctFloatArray)")
        
        for i in 0 ..< sectionTitle.count {
            let sectionNum = i
            for x in 0 ..< cellTitle[sectionNum].count {
                dataArray = loadCSV(fileName: "quiz\(sectionNum)_\(x)")
                totalCount = Float(dataArray.count)
                //totalFloatArray.append(totalCount)
                totalFloatArray[sectionNum].append(totalCount)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! LevelTableViewCell
        
        if indexPath.section != 0 {
            //TOEIC
            if categoryNumber == 0 {
                cell.LevelLabel?.text = cellTitle[indexPath.section][indexPath.row]
                cell.WordCountLabel?.text = "\(Int(correctFloatArray[indexPath.section][indexPath.row])) / \(Int(totalFloatArray[indexPath.section][indexPath.row]))"
                cell.ProgerssBar.progress = correctFloatArray[indexPath.section][indexPath.row] / totalFloatArray[indexPath.section][indexPath.row]
                cell.ProgerssBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //英検
            } else {
                cell.LevelLabel?.text = cellTitle[indexPath.section][indexPath.row]
                cell.WordCountLabel?.text = "\(Int(correctFloatArray[indexPath.section][indexPath.row])) / \(Int(totalFloatArray[indexPath.section][indexPath.row]))"
                cell.ProgerssBar.progress = correctFloatArray[indexPath.section][indexPath.row] / totalFloatArray[indexPath.section][indexPath.row]
                cell.ProgerssBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toQuizVC" {
            if let indexPath = MyTableView.indexPathForSelectedRow {
                let quizVC = segue.destination as! QuizViewController
                quizVC.selectLevel = indexPath.row
                quizVC.selectSection = indexPath.section
                print(quizVC.selectLevel)
                print(quizVC.selectSection)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = MyTableView.indexPathForSelectedRow {
            MyTableView.deselectRow(at: indexPath, animated: true)
        }
        correctArray = []
        correctFloatArray = [[]]
        totalFloatArray = [[]]
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

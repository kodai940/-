//
//  GradeTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/20.
//

import UIKit
import RealmSwift

class GradeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var MyTableView: UITableView!
    
    var csvArray: [String] = []
    var dataArray0_0: [String] = []
    
    var cellTitleCount: Int = 0
    
    var dataArray: [String] = []
    var correctArray: [Int] = []
    var totalCount: Float = 0.0
    var dataCount: Int = 0
    
    var correctFloatArray = [[Float]]()
    var totalFloatArray = [[Float]]()
    
    var sectionTitle: [String] = []
    var cellTitle = [[String]]()

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyTableView.delegate = self
        MyTableView.dataSource = self
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(setButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = settingButton
        settingButton.tintColor = .systemOrange
    }
    
    @objc func setButtonTapped(_ sender: Any?) {
        print("設定")
        let settingView = self.storyboard?.instantiateViewController(withIdentifier: "settingView") as! SettingTableViewController
        settingView.presentationController?.delegate = self
        let nav = UINavigationController(rootViewController: settingView)
        present(nav, animated: true, completion: nil)
    }
    
    func loadData() {
        sectionTitle = ["TOEIC-Score 600 Level"]
        
//        sectionTitle = ["回答状況","品詞","レベル別","ビジネス関連","さらに絞りこむ"]
        
        for _ in 0 ... 0 {
            cellTitle.append([])
            correctFloatArray.append([])
            totalFloatArray.append([])
        }
        
        cellTitle[0] = ["Grade 1","Grade 2","Grade 3"]
        
        cellTitleCount = cellTitle[0].count
        
        let results = realm.objects(CorrectNumberTOEIC.self)
        let correctArray = results.map { $0.correctNumberToeic }
        
        correctFloatArray = [
            [0..<101, 101..<201, 201..<301].map { range in
                Float(correctArray.filter { range.contains($0) }.count )
            }
        ]

        for i in 0 ..< sectionTitle.count {
            let sectionNum = i
            for x in 0 ..< cellTitle[sectionNum].count {
                print(x)
                dataArray = loadCSV(fileName: "quiz\(sectionNum)_\(x)")
                totalCount = Float(dataArray.count)
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
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GradeTableViewCell

        cell.GradeLabel?.text = cellTitle[indexPath.section][indexPath.row]
        cell.WordCountLabel?.text = "\(Int(correctFloatArray[indexPath.section][indexPath.row])) / \(Int(totalFloatArray[indexPath.section][indexPath.row]))"
        cell.ProgressBar.progress = correctFloatArray[indexPath.section][indexPath.row] / totalFloatArray[indexPath.section][indexPath.row]
        cell.ProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toQuizVC" {
            if let indexPath = MyTableView.indexPathForSelectedRow {
                let quizVC = segue.destination as! QuizViewController
                quizVC.selectLevel = indexPath.row
                quizVC.selectSection = indexPath.section
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

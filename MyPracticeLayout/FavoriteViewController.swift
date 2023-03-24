//
//  FavoriteViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/13.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MyTableView: UITableView!
    
    var favoriteNum:[Int] = []
    var favoriteArray: [String] = []
    var wordArray: String = ""
    let realm = try! Realm()
    var deleteNum = 0
    
    var csvArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyTableView.delegate = self
        MyTableView.dataSource = self
        MyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction(_:)))
        
        let quizButton = UIBarButtonItem(title: "単語テスト", style: .done, target: self, action: #selector(quizButtonAction(_:)))
        
        self.navigationItem.rightBarButtonItem = quizButton
        self.navigationItem.leftBarButtonItem = addButton
        
        self.navigationItem.rightBarButtonItem?.tintColor = .systemOrange
        self.navigationItem.leftBarButtonItem?.tintColor = .systemOrange
        
        loadData()
        
        if favoriteNum.count == 0 {
            quizButton.isEnabled = false
        }
    }
    
    func loadData() {
        
        let fileNames = ["TOEIC600"]
//        let fileNames = ["TOEIC600","TOEIC700","TOEIC800","TOEIC900"]
        csvArray = fileNames.flatMap { loadCSV(fileName: $0) }
        
        let favoriteResults = realm.objects(FavoriteNumberTOEIC.self)
        
        for i in 0 ..< favoriteResults.count {
            favoriteNum.append(favoriteResults[i].favoriteNumberToeic)
        }
        
        for i in 0 ..< favoriteNum.count {
            let x = favoriteNum[i]
            var quizArray = csvArray[x].components(separatedBy: ",")
            quizArray.removeSubrange(1..<9)
            wordArray = quizArray.joined(separator: ",")
            favoriteArray.append(wordArray)
        }
    }
    
    //単語を追加
    @objc func addButtonAction(_ sender: Any) {
        let storyboard = self.storyboard!
        let addVC = storyboard.instantiateViewController(withIdentifier: "addViewController") as! AddViewController
        addVC.presentationController?.delegate = self
        let nav = UINavigationController(rootViewController: addVC)
        nav.modalPresentationStyle = .fullScreen
        nav.presentationController?.delegate = self
        self.present(nav, animated: true, completion: nil)
    }
    
    //クイズを始める
    @objc func quizButtonAction(_ sender: Any) {
        let storyboard = self.storyboard!
        let quizVC = storyboard.instantiateViewController(withIdentifier: "quizViewController") as! QuizViewController
        quizVC.favoriteNum = favoriteNum
        quizVC.favoriteKey = true
        quizVC.modalPresentationStyle = .fullScreen
        self.present(quizVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if favoriteNum.count == 0 {
            return "左上の+ボタンで単語を追加できます"
        } else {
            return "左にスワイプすると単語を削除できます"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray2
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = favoriteArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let targetNumber = realm.objects(FavoriteNumberTOEIC.self).filter("favoriteNumberToeic == \(favoriteNum[indexPath.row])")
            do {
                print("delete \(targetNumber)")
                try realm.write {
                    realm.delete(targetNumber)
                }
            } catch {
                print("error\(error)")
            }
            favoriteNum.remove(at: indexPath.row)
            favoriteArray.remove(at: indexPath.row)
            MyTableView.deleteRows(at: [indexPath], with: .automatic)
            MyTableView.reloadData()
            
            if let barButtonItem = navigationItem.rightBarButtonItem {
                if favoriteNum.count == 0 {
                    barButtonItem.isEnabled = false
                }
            }
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
}

extension FavoriteViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("dismiss")
        
        favoriteNum = []
        favoriteArray = []
        loadData()
        MyTableView.reloadData()
        
        if let barButtonItem = navigationItem.rightBarButtonItem {
            if favoriteNum.count > 0 {
                barButtonItem.isEnabled = true
            }
        }
    }
}

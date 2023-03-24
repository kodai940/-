//
//  AddViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/13.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var MySearchBar: UISearchBar!
    
    var csvArray: [String] = []
    
    var quizArray: [String] = []
    var wordArray: String = ""
    var referenceArray: [String] = []
    var searchdata: [String] = []
    var registNum: [Int] = []
    var favoriteNum: [Int] = []
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileNames = ["TOEIC600"]
//        let fileNames = ["TOEIC600","TOEIC700","TOEIC800","TOEIC900"]
        csvArray = fileNames.flatMap { loadCSV(fileName: $0) }
        
        let favoriteResults = realm.objects(FavoriteNumberTOEIC.self)
        
        for i in 0 ..< favoriteResults.count {
            favoriteNum.append(favoriteResults[i].favoriteNumberToeic)
        }

        for i in 0 ..< csvArray.count {
            quizArray = csvArray[i].components(separatedBy: ",")
            quizArray.removeSubrange(1..<9)
            wordArray = quizArray.joined(separator: ",")
            referenceArray.append(wordArray)
        }
        
        MySearchBar.autocapitalizationType = .none
        MyTableView.allowsMultipleSelection = true
        MyTableView.delegate = self
        MyTableView.dataSource = self
        MySearchBar.delegate = self
        
        let barButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(topButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        barButton.tintColor = .systemOrange
    }
    
    @objc func topButtonAction(_ sender:Any) {
        for i in 0 ..< registNum.count {
            if !favoriteNum.contains(registNum[i]) {
                do {
                    let favoriteNumber: FavoriteNumberTOEIC = FavoriteNumberTOEIC(value: ["favoriteNumberToeic" : registNum[i]])
                    try realm.write {
                        realm.add(favoriteNumber)
                    }
                } catch {
                    print("error\(error)")
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MySearchBar?.text != "" {
            return searchdata.count
        } else {
            return referenceArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddTableViewCell
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.systemGray4
        cell.selectedBackgroundView = cellSelectedBgView
        
        if MySearchBar.text != "" {
            cell.WordLabel?.text = searchdata[indexPath.row]
        } else {
            cell.WordLabel?.text = referenceArray[indexPath.row]
        }
        
        for i in 0 ..< favoriteNum.count {
            if cell.WordLabel?.text == referenceArray[favoriteNum[i]] {
                cell.accessoryType = .checkmark
                cell.backgroundColor = .systemGray4
                cell.isUserInteractionEnabled = false
            }
        }
        
        for i in 0 ..< registNum.count {
            if cell.WordLabel?.text == referenceArray[registNum[i]] {
                cell.accessoryType = .checkmark
                cell.backgroundColor = .systemGray4
                cell.isUserInteractionEnabled = false
            }
        }
        return cell
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        MySearchBar.text = ""
        MySearchBar.endEditing(true)
        MyTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = MyTableView.cellForRow(at: indexPath) as! AddTableViewCell
        print("select")
        cell.accessoryType = .checkmark
        cell.isUserInteractionEnabled = false
        for i in 0 ..< referenceArray.count {
            if cell.WordLabel.text == referenceArray[i] {
                registNum.append(i)
            }
        }
        print(registNum)
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let keyword = MySearchBar.text, !keyword.isEmpty {
            searchdata = referenceArray.filter { $0.contains(keyword) }
        } else {
            searchdata = []
        }
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

extension AddViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

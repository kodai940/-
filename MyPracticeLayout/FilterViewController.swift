//
//  FilterViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/03/12.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var choicedLevel: [String] = []
    var choicedType: [String] = []
    var choicedWC: [String] = []
    var choicedTag: [String] = []
    let wcString: [String] = ["間違えた単語","正解した単語","未回答"]
    let typeString: [String] = ["名詞","動詞","形容詞","副詞","熟語"]
    let levelString: [String] = ["TOEIC600点レベル","TOEIC700点レベル","TOEIC800点レベル","TOEIC900点レベル"]
    let businessString: [String] = ["住宅・不動産","商取引・販売","運送・納品","広告・宣伝","流行・普及","損害賠償・保険","企業形態・企業関連","雇用・求人募集","給料・手当","連絡(手紙・メール・電話)","財務・会計","裁判・法律","会議・議論","報道・出版","職業名","役職・部署","事務用品・日常用品","値段・料金"]
    let tagString: [String] = ["数量表現","位置・配置に関する表現","時間・頻度に関する表現","学問名","間違えやすい単語"]
    //流行、値段・料金
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(compBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = .systemOrange
        self.navigationItem.title = "フィルター"
        
        myTableView.allowsMultipleSelection = true
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.tableFooterView = UIView()

    }
    
    @objc func compBarButtonTapped(_ sender: UIBarButtonItem) {
        print("complete")
        
        let tabVC = self.presentingViewController as! UITabBarController
        let nav = tabVC.selectedViewController as! UINavigationController
        let vc = nav.topViewController as! SearchTableViewController
        
        vc.selectedLevel = choicedLevel
        vc.selectedType = choicedType
        vc.selectedWC = choicedWC
        vc.selectedTag = choicedTag
     
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return wcString.count
        case 1:
            return typeString.count
        case 2:
            return levelString.count
        case 3:
            return businessString.count
        case 4:
            return tagString.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
        //  header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "品詞"
        case 2:
            return "レベル別"
        case 3:
            return "ビジネス関連"
        case 4:
            return "さらに絞りこむ"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = myTableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            choicedWC.append(wcString[indexPath.row])
            print(choicedWC)
        }
        if indexPath.section == 1 {
            choicedType.append(typeString[indexPath.row])
            print(choicedType)
        }
        if indexPath.section == 2 {
            choicedLevel.append(levelString[indexPath.row])
            print(choicedLevel)
        }
        if indexPath.section == 3 {
            choicedTag.append(businessString[indexPath.row])
            print(choicedTag)
        }
        if indexPath.section == 4 {
            choicedTag.append(tagString[indexPath.row])
            print(choicedTag)
        }
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = myTableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            choicedWC.removeAll(where: {$0 == wcString[indexPath.row]} )
            print(choicedWC)
        }
        if indexPath.section == 1 {
            choicedType.removeAll(where: {$0 == typeString[indexPath.row]} )
            print(choicedType)
        }
        if indexPath.section == 2 {
            choicedLevel.removeAll(where: {$0 == levelString[indexPath.row]} )
            print(choicedLevel)
        }
        if indexPath.section == 3 {
            choicedTag.removeAll(where: {$0 == businessString[indexPath.row]} )
            print(choicedTag)
        }
        if indexPath.section == 4 {
            choicedTag.removeAll(where: {$0 == tagString[indexPath.row]} )
            print(choicedTag)
        }
        cell?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterTableViewCell
        
        if indexPath.section == 0 {
            cell.FilterLabel.text = wcString[indexPath.row]
        } else if indexPath.section == 1 {
            cell.FilterLabel.text = typeString[indexPath.row]
        } else if indexPath.section == 2 {
            cell.FilterLabel.text = levelString[indexPath.row]
        } else if indexPath.section == 3 {
            cell.FilterLabel.text = businessString[indexPath.row]
        } else {
            cell.FilterLabel.text = tagString[indexPath.row]
        }
        return cell
    }
}
    
extension FilterViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

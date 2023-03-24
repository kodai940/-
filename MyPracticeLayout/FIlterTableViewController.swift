//
//  FIlterTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/22.
//

import UIKit

class FIlterTableViewController: UITableViewController {
    var choicedLevel: [String] = []
    var choicedType: [String] = []
    var choicedWC: [String] = []
    var choicedTag: [String] = []
    let wcString: [String] = ["間違えた単語","正解した単語","未回答"]
    let typeString: [String] = ["名詞","動詞","形容詞","副詞","熟語"]
    let levelString: [String] = ["TOEIC600点レベル","TOEIC700点レベル","TOEIC800点レベル","TOEIC900点レベル"]
    let tagString: [String] = ["数量表現","位置・配置に関する表現","時間・頻度に関する表現","句動詞","職業名","役職・部署名","事務用品・日常用品","学問","料金・運賃","間違えやすい単語","ビジネス関連"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(compBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = .systemOrange
        self.navigationItem.title = "フィルター"
        
        tableView.allowsMultipleSelection = true
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
        
//        let countLevels = vc.selectedLevel.count
//        let countTypes = vc.selectedType.count
//        let countWCs = vc.selectedWC.count
//
//        let filterConditions = [
//            (countLevels > 0 && countTypes > 0 && countWCs > 0, { vc.filterIson = true }),
//            (countLevels > 0 && countTypes > 0 && countWCs == 0, { vc.levelTypeIson = true }),
//            (countLevels > 0 && countTypes == 0 && countWCs > 0, { vc.levelWCIson = true }),
//            (countLevels == 0 && countTypes > 0 && countWCs > 0, { vc.typeWCIson = true }),
//            (countLevels > 0 && countTypes == 0 && countWCs == 0, { vc.levelIson = true }),
//            (countLevels == 0 && countTypes > 0 && countWCs == 0, { vc.typeIson = true }),
//            (countLevels == 0 && countTypes == 0 && countWCs > 0, { vc.wcIson = true })
//        ]
//
//        if let condition = filterConditions.first(where: { $0.0 }) {
//            condition.1()
//        }
        
//        if vc.selectedLevel.count != 0 && vc.selectedType.count != 0 && vc.selectedWC.count != 0 {
//            vc.filterIson = true
//        } else if vc.selectedLevel.count != 0 && vc.selectedType.count != 0 && vc.selectedWC.count == 0 {
//            vc.levelTypeIson = true
//        } else if vc.selectedLevel.count != 0 && vc.selectedType.count == 0 && vc.selectedWC.count != 0 {
//            vc.levelWCIson = true
//        } else if vc.selectedLevel.count == 0 && vc.selectedType.count != 0 && vc.selectedWC.count != 0 {
//            vc.typeWCIson = true
//        } else if vc.selectedLevel.count != 0 && vc.selectedType.count == 0 && vc.selectedWC.count == 0 {
//            vc.levelIson = true
//        } else if vc.selectedLevel.count == 0 && vc.selectedType.count != 0 && vc.selectedWC.count == 0 {
//            vc.typeIson = true
//        } else if vc.selectedLevel.count == 0 && vc.selectedType.count == 0 && vc.selectedWC.count != 0 {
//            vc.wcIson = true
//        }
        
        
//        print(vc.filterIson)
//        print(vc.levelTypeIson)
//        print(vc.wcIson)
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 5
        case 2:
            return 4
        case 3:
            return 11
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
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
            choicedTag.append(tagString[indexPath.row])
            print(choicedTag)
        }
        cell?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
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
            choicedTag.removeAll(where: {$0 == tagString[indexPath.row]} )
        }
        cell?.accessoryType = .none
    }
}

extension FIlterTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

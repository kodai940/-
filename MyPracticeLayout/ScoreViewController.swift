//
//  ScoreViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/08.
//

import UIKit
import StoreKit
import MBCircularProgressBar
import GoogleMobileAds



class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bannerView: GADBannerView!
    var count = 0
    var listArray: [String] = []
    var correctArray: [Int] = []
    var quizArray: [String] = []
    var engArray: [String] = []
    var janArray: [String] = []
    
    var nextQuizCount = 0
    
    @IBOutlet weak var MyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyTableView.delegate = self
        MyTableView.dataSource = self
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
        
        let backButton = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(backButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .systemOrange
        
        let nextButton = UIBarButtonItem(title: "次の問題へ(\(nextQuizCount))", style: .done, target: self, action: #selector(nextButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = nextButton
        nextButton.tintColor = .systemOrange
        
        if nextQuizCount == 0 {
            nextButton.isEnabled = false
        }

        for i in 0 ..< listArray.count {
            quizArray = listArray[i].components(separatedBy: ",")
            quizArray.removeSubrange(1..<9)
            engArray.append(quizArray[0])
            janArray.append(quizArray[1])
        }
    }
    
    @objc func backButtonAction(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func nextButtonAction(_ sender: Any) {
        listArray = []
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return engArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 270
        } else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = MyTableView.dequeueReusableCell(withIdentifier: "MyScoreCell", for: indexPath) as! ScoreTableViewCell
            cell.isUserInteractionEnabled = false
        
            //MBCircularProgressBar
            //最大値
            cell.progressView.maxValue = CGFloat(listArray.count)
            //値
            cell.progressView.value = CGFloat(count)
            
            //色  Red:255 Green:221 Blue:21 #FFDD15
            //.Color = UIColor(red: 255/255, green: 210/255, blue: 103/255, alpha: 1.0)
        
            cell.progressView.progressColor = UIColor(red: 255/255, green: 183/255, blue: 73/255, alpha: 1.0)
            //cell.progressView.progressColor = UIColor(red: 113/255, green: 255/255, blue: 159/255, alpha: 1.0)
            //開始位置
            cell.progressView.progressRotationAngle = 50
            //円周
            cell.progressView.progressAngle = 150
            //幅
            cell.progressView.progressLineWidth = 13
            //空白部分の幅
            cell.progressView.emptyLineWidth = 11
            //輪郭色
            cell.progressView.progressStrokeColor = .clear
            cell.progressView.backgroundColor = .white
            
            //バー内に文字を表示
            cell.progressView.fontColor = .darkGray
            
            cell.progressView.showUnitString = true
            cell.progressView.unitFontSize = 30
            cell.progressView.unitFontName = UIFont(name: "Avenir-Heavy", size: 30)?.fontName
            cell.progressView.unitString = " / \(listArray.count)"
            
            cell.progressView.showValueString = true
            cell.progressView.valueFontSize = 30
            cell.progressView.valueFontName = UIFont(name: "Avenir-Heavy", size: 30)?.fontName
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLabelCell", for: indexPath) as! LabelTableViewCell
            
            cell.isUserInteractionEnabled = false
            cell.WordLabel.text? = "\(engArray[indexPath.row])"
            cell.meaningLabel.text? = "\(janArray[indexPath.row])"
            cell.WordLabel.font = UIFont.systemFont(ofSize: 17)
            cell.meaningLabel.font = UIFont.systemFont(ofSize: 15)
            
            if correctArray.contains(indexPath.row) {
                cell.CWImage?.image = UIImage(named: "checkbox")
            } else {
                 cell.CWImage?.image = UIImage(named: "checkbox_empty")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 27
        } else {
            return 27
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "テスト結果"
        } else {
            return "回答詳細"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            // 背景色を変更する
            view.tintColor = UIColor(red: 255/255, green: 183/255, blue: 73/255, alpha: 1.0)
            let header = view as! UITableViewHeaderFooterView
            // テキスト色を変更する
            header.textLabel?.textColor = .white

            header.textLabel?.textAlignment = .center
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            view.tintColor = .systemGray6
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = .darkGray
            header.textLabel?.textAlignment = .center
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
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

extension ScoreViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

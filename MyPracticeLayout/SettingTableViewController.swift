//
//  SettingTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/02/27.
//

import UIKit
import MessageUI

class SettingTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let userDefaults: UserDefaults = UserDefaults.standard
    let defaultValues = ["wordCount": 10, "bgmCW": true, "bgmP": true, "speed": 0.005] as [String : Any]
    var wordCount = 0
    var speed = 0.0

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countStepper: UIStepper!
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.register(defaults: defaultValues)
        wordCount = UserDefaults.standard.integer(forKey: "wordCount")
        speed = UserDefaults.standard.double(forKey: "speed")
        
        switch1.isOn = userDefaults.bool(forKey: "bgmCW")
        switch2.isOn = userDefaults.bool(forKey: "bgmP")
        
        let barButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(compBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = .systemOrange
        countLabel.text = "単語数: \(wordCount)"
        countStepper.value = Double(wordCount)
        
        speedStepper.stepValue = 0.002
        speedStepper.minimumValue = 0.003
        speedStepper.maximumValue = 0.007
        speedStepper.value = speed
        
        if speed == 0.003 {
            speedLabel.text = "3s（速い）"
        } else if speed == 0.005 {
            speedLabel.text = "5s（普通）"
        } else if speed == 0.007 {
            speedLabel.text = "7s（ゆっくり）"
        }
        //
        print("wordCountは\(wordCount)です")
        print("switch1.isOnは\(switch1.isOn)です")
        print("switch2.isOnは\(switch2.isOn)です")
        print("speedは\(speed)です")
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeStepperValue(sender: UIStepper) {
        let intValue = Int(sender.value)
        countLabel.text = "単語数: \(intValue)"
        userDefaults.set(intValue, forKey: "wordCount")
    }
    
    @IBAction func changeSpeedValue(sender: UIStepper) {
        if sender.value == 0.003 {
            speedLabel.text = "3s（速い）"
        } else if sender.value == 0.005 {
            speedLabel.text = "5s（普通）"
        } else if sender.value == 0.007 {
            speedLabel.text = "7s（ゆっくり）"
        }
        print(sender.value)
        userDefaults.set(sender.value, forKey: "speed")
    }
    
    @objc func compBarButtonTapped(_ sender: UIBarButtonItem) {
        print("完了")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uiSwitch1(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "bgmCW")
    }
    
    @IBAction func uiSwitch2(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "bgmP")
    }
    
    @IBAction func contactButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["○○○@email.com"]) //宛先
            mail.setSubject("お問い合わせ") //件名
            mail.setMessageBody("本文", isHTML: false) //本文
            present(mail, animated: true, completion: nil)
        } else {
            print("送信できません")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書き保存")
        case .sent:
            print("送信成功")
        default:
            print("送信失敗")
        }
        dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
}

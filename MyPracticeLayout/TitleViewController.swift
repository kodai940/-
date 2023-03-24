//
//  TitleViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/02.
//

import UIKit

class TitleViewController: UIViewController {

    @IBOutlet weak var TestButton: UIButton!
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var SettingButton: UIButton!
    
    let settingImage = UIImage(named: "setting64px")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        ButtonDesign()
    }
}

extension TitleViewController {
    func ButtonDesign() {
        TestButton.layer.cornerRadius = 20
        FavoriteButton.layer.cornerRadius = 20
        
        TestButton.layer.borderColor = UIColor.orange.cgColor
        FavoriteButton.layer.borderColor = UIColor.orange.cgColor
        
        TestButton.layer.borderWidth = 2
        FavoriteButton.layer.borderWidth = 2
    }
}

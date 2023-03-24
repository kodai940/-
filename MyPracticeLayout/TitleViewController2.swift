//
//  TitleViewController2.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/19.
//

import UIKit

class TitleViewController2: UIViewController {

    @IBOutlet weak var FilterButton: UIButton!
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var SettingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FilterButton.tintColor = .systemYellow
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

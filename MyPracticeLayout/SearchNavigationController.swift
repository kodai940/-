//
//  SearchNavigationController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/05.
//

import UIKit

class SearchNavigationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quizButton = UIBarButtonItem(title: "テスト", style: .done, target: self, action: #selector(quizBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = quizButton
    }
    
    @objc func quizBarButtonTapped(_ sender: UIBarButtonItem) {
        print("テスト")
    }
    
    
    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        print("フィルター")
    }
    
}

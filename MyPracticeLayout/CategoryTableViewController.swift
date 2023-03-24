//
//  CategoryTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/02.
//

import UIKit

class CategoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var MyTableView: UITableView!
    
    let categoryTitle = ["TOEIC", "英検"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyTableView.delegate = self
        MyTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        MyTableView.rowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.textLabel?.text = categoryTitle[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLevelSegue" {
            if let indexPath = MyTableView.indexPathForSelectedRow {
                guard let destination = segue.destination as? LevelTableViewController else {
                    fatalError("Failed to prepare LevelTableViewController")
                }
                print(indexPath.row)
                destination.categoryNumber = indexPath.row
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = MyTableView.indexPathForSelectedRow {
            MyTableView.deselectRow(at: indexPath, animated: true)
        }
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

//
//  AddFilterTableViewController.swift
//  MyPracticeLayout
//
//  Created by user on 2023/02/23.
//

import UIKit

class AddFilterTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 9
        default:
            return 0
        }
    }
}

//
//  CountTableViewCell.swift
//  MyPracticeLayout
//
//  Created by user on 2023/03/20.
//

import UIKit

class CountTableViewCell: UITableViewCell {

    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

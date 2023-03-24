//
//  SearchCell.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/22.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var LevelTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

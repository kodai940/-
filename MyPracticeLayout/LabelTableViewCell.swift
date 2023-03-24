//
//  LabelTableViewCell.swift
//  MyPracticeLayout
//
//  Created by user on 2023/03/03.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var CWImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

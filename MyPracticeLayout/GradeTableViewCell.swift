//
//  GradeTableViewCell.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/20.
//

import UIKit

class GradeTableViewCell: UITableViewCell {

    @IBOutlet weak var GradeLabel: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var WordCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

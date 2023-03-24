//
//  ScoreTableViewCell.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/10.
//

import UIKit
import MBCircularProgressBar

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var CircularBar: UIView!
    let progressView = MBCircularProgressBarView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CircularBar.addSubview(progressView)
        progressView.frame = CircularBar.bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

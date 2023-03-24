//
//  LevelTableViewCell.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/02.
//

import UIKit

class LevelTableViewCell: UITableViewCell {

    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var WordCountLabel: UILabel!
    @IBOutlet weak var ProgerssBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

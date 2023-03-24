//
//  AddTableViewCell.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/16.
//

import UIKit

class AddTableViewCell: UITableViewCell {
    
    @IBOutlet weak var WordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.WordLabel?.text = ""
        self.accessoryType = .none
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

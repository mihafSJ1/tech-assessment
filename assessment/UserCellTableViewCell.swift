//
//  UserCellTableViewCell.swift
//  assessment
//
//  Created by Mihaf on 16/11/1442 AH.
//

import UIKit

class UserCellTableViewCell: UITableViewCell {

    @IBOutlet weak var genderOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UILabel!
    @IBOutlet weak var emailOutlet: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

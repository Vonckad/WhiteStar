//
//  SubCategoryTableViewCell.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 1/10/21.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

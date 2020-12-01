//
//  MyTableViewCell.swift
//  HomeWork_14_1
//
//  Created by Vlad Ralovich on 9/7/20.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLableCell: UILabel!
    @IBOutlet var priceLableCell: UILabel!
    @IBOutlet var sizebleCell: UILabel!
    
    @IBOutlet var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    
}

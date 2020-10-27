//
//  DailyWeatherTableViewCell.swift
//  HomeWork_12_Carthage
//
//  Created by Vlad Ralovich on 6/22/20.
//  Copyright © 2020 Vonkad. All rights reserved.
//

import UIKit

class CellCategory: UITableViewCell {

    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
    }
    static func nib() -> UINib {
        return UINib(nibName: "CellCategory", bundle: nil)
    }
    
    func configurate(with cat: CategoryArray) {
        categoryLabel.text = cat.name
    }
}

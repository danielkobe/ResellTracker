//
//  CustomCell.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/19/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit

class ShoeCell: UITableViewCell {
    
    
    @IBOutlet weak var shoeImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

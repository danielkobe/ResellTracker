//
//  HeaderCell.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/22/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var sizeHeader: UILabel!
    @IBOutlet weak var goatImage: UIImageView!
    @IBOutlet weak var stockXImage: UIImageView!
    @IBOutlet weak var stadiumGoodsImage: UIImageView!
    @IBOutlet weak var flightClubImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

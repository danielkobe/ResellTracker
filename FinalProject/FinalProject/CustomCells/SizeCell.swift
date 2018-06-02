//
//  SizeCell.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/23/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit

class SizeCell: UITableViewCell {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var goatPriceLabel: UILabel!
    @IBOutlet weak var stockXPriceLabel: UILabel!
    @IBOutlet weak var stadiumGoodsPriceLabel: UILabel!
    @IBOutlet weak var flightClubPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

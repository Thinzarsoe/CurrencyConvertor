//
//  currencyTableViewCell.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/18/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class currencyTableViewCell: UITableViewCell {

    @IBOutlet weak var flagLabel: UILabel!
    

    @IBOutlet weak var currencyLabel:UILabel!
    @IBOutlet weak var countrynameLabel:UILabel!
    @IBOutlet weak var rateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

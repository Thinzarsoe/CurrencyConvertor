//
//  historyTableViewCell.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/20/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class historyTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    
    @IBOutlet weak var toLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

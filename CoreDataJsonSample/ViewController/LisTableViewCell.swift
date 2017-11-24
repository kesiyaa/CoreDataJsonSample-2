//
//  LisTableViewCell.swift
//  coreDataJsonSample
//
//  Created by MAC on 23/11/17.
//  Copyright © 2017 CCS. All rights reserved.
//

import UIKit

class LisTableViewCell: UITableViewCell {

    @IBOutlet var label2: UILabel!
    @IBOutlet var label1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

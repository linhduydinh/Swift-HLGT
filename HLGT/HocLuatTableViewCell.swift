//
//  HocLuatTableViewCell.swift
//  HLGT
//
//  Created by MAC on 7/27/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class HocLuatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var hocLuatImage: UIImageView!
    
    @IBOutlet weak var hocLuatTitle: UILabel!
    
    
    @IBOutlet weak var categoryId: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

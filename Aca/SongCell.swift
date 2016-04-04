//
//  SongCell.swift
//  Aca
//
//  Created by patron on 4/2/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var songName: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  IdeaCell.swift
//  Aca
//
//  Created by patron on 4/4/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import UIKit

class IdeaCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var ideaName: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

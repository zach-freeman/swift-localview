//
//  PhotoTableCellTableViewCell.swift
//  localview
//
//  Created by Zach Freeman on 8/13/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit

class PhotoTableCell: UITableViewCell {

  @IBOutlet weak var previewImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

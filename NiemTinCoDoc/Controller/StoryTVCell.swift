//
//  StoryTVCell.swift
//  NiemTinCoDoc
//
//  Created by Nguyen Hieu Trung on 4/11/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import UIKit

class StoryTVCell: UITableViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var viewInCell: UIView!
    @IBOutlet weak var lblStoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

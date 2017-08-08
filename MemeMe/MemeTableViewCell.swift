//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Alessandro Bellotti on 08/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    // MARK: IBOutlet
    
    @IBOutlet weak var listCellImageView: UIImageView!
    @IBOutlet weak var memeTopText: UILabel!
    @IBOutlet weak var memeBottomText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

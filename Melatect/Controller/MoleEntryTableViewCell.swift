//
//  MoleEntryTableViewCell.swift
//  Melatect
//
//  Created by 01100001 01110011 01110010 01101001 01110100 01101000 01100001 on 4/21/21.
//

import UIKit

class MoleEntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var diagnosis: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var scheduled: UILabel!
    @IBOutlet weak var grayBackground: UIView!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        grayBackground.layer.cornerRadius = 30
        mainImageView.layer.cornerRadius = 15 //This will change with corners of image and height/2 will make this circle shape
        mainImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

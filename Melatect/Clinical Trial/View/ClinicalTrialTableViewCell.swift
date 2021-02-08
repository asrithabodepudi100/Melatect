//
//  ClinicalTrialTableViewCell.swift
//  Melatect
//
//  Created by Asritha Bodepudi  on 1/20/21.
//

import UIKit

class ClinicalTrialTableViewCell: UITableViewCell {

    @IBOutlet weak var grayBackground: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var melatectDiagnosis: UILabel!
    @IBOutlet weak var doctorDiagnosis: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        grayBackground.layer.cornerRadius = 30
        mainImageView.layer.cornerRadius = 15 //This will change with corners of image and height/2 will make this circle shape
        mainImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

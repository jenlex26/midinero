//
//  BASACardCell.swift
//  TEST3
//
//  Created by Desarrollo on 21/05/21.
//

import UIKit

class BASACardCell: UICollectionViewCell {
    
    @IBOutlet weak var CardBackgroundView: UIView!
    @IBOutlet weak var lblCardNumber     : UILabel!
    @IBOutlet weak var lblExpDate        : UILabel!
    @IBOutlet weak var lblBalance        : UILabel!
    @IBOutlet weak var lblVigencia       : UILabel!
    @IBOutlet weak var lblOweMoney       : UILabel!
    @IBOutlet weak var btnConfig         : UIButton!
    @IBOutlet weak var cardImage        : UIImageView!
    @IBOutlet weak var bazIcon         : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnConfig.layer.masksToBounds = true
        btnConfig.layer.cornerRadius = btnConfig.frame.width/2
    }
    
    
}

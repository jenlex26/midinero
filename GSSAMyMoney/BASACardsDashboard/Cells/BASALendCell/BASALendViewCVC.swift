//
//  BASALendViewCVC.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit
import GSSAVisualComponents

class BASALendViewCVC: UICollectionViewCell {

    @IBOutlet weak var lblAmount        : GSVCLabel!
    @IBOutlet weak var lblSubtitle      : GSVCLabel!
    @IBOutlet weak var lblDescription   : GSVCLabel!
    @IBOutlet weak var btnConfig        : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnConfig.backgroundColor = UIColor(red: 91/255, green: 157/255, blue: 71/255, alpha: 1.0)
        btnConfig.layer.masksToBounds = true
        btnConfig.layer.cornerRadius = btnConfig.frame.width/2
    }

}

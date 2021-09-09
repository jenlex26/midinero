//
//  BASAInfoCardCell.swift
//  GSSAFront
//
//  Created by Andoni Suarez on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class BASAInfoCardCell: UITableViewCell {

    @IBOutlet weak var lblText      : GSVCLabel!
    @IBOutlet weak var infoCardIcon : UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        if #available(iOS 13.0, *){
            print("")
        }else{
            infoCardIcon.imageView?.contentMode = .scaleAspectFit
            infoCardIcon.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3.0, right: 3.0)
            infoCardIcon.setImage(UIImage(named: "alert", in: Bundle.init(for: BASABeneficiaryListViewController.self), compatibleWith: nil), for: .normal)
        }
    }
    
}

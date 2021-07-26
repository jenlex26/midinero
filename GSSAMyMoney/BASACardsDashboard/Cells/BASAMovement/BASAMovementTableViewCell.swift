//
//  BASAMovementTableViewCell.swift
//  BASAMyPaymentsScreens
//
//  Created by Andoni Suarez on 18/05/21
//

import UIKit
import GSSAVisualComponents

class BASAMovementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var lblAmount: GSVCLabel!
    @IBOutlet weak var lblDate: GSVCLabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setArrow(amount: String){
        if #available(iOS 13.0, *) {
            if amount.contains("-"){
                imgView.image = UIImage(systemName: "arrow.left")
                imgView.tintColor = .systemPink
            }else{
                imgView.image = UIImage(systemName: "arrow.right")
                imgView.tintColor = .systemGreen
            }
        }else{
            imgView.isHidden = true
        }
    }
}

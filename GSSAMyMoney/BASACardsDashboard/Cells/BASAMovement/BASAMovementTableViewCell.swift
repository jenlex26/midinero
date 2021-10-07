//
//  BASAMovementTableViewCell.swift
//  BASAMyPaymentsScreens
//
//  Created by Andoni Suarez on 18/05/21
//

import UIKit
import GSSAVisualComponents

class BASAMovementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : GSVCLabel!
    @IBOutlet weak var lblAmount: GSVCLabel!
    @IBOutlet weak var lblDate  : GSVCLabel!
    @IBOutlet weak var imgView  : UIImageView!
    @IBOutlet weak var separator : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setArrow(amount: String){
        if amount.contains("-"){
            imgView.image = UIImage.arrowLeft()
            imgView.tintColor = .systemPink
        }else{
            imgView.image = UIImage.arrowRight()
            imgView.tintColor = .systemGreen
        }
    }
    
    func setArrow(idTipo: String){
        if idTipo == "A"{
            imgView.image = UIImage.arrowRight()
            imgView.tintColor = .systemGreen
        }else if idTipo == "C"{
            imgView.image = UIImage.arrowLeft()
            imgView.tintColor = .systemPink
        }else{
            imgView.isHidden = true
        }
    }
}

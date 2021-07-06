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

extension String{
    func moneyFormat() -> String{
        var stringAmount = ""
        guard let formatedAmount = Double(self) else{
            return self
        }
        
        stringAmount = String(formatedAmount)
        
        let amountFormat = NSMutableAttributedString.setFormattedText(withStringAmmount: stringAmount,
                                                                      withNumberOfDecimals: 2,
                                                                      withFontSize: 36,
                                                                      withFontWeight: .bold,
                                                                      withFontColor: .GSVCText100,
                                                                      withLittleCoin: false)
        
        return amountFormat.mutableString.description
    }
}

extension Int{
    func moneyFormat() -> String{
        
        let doubleAmount = Double(self)
        
        let stringAmount = String(doubleAmount)
        
        let amountFormat = NSMutableAttributedString.setFormattedText(withStringAmmount: stringAmount,
                                                                      withNumberOfDecimals: 2,
                                                                      withFontSize: 36,
                                                                      withFontWeight: .bold,
                                                                      withFontColor: .GSVCText100,
                                                                      withLittleCoin: false)
        return amountFormat.mutableString.description
    }
}

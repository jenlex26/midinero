//
//  BASACardLimitCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 14/06/21.
//

import UIKit
import GSSAVisualComponents
import GSSASessionInfo

class BASACardLimitCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var btnEdit: GSVCButton!
    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var lblSubtitle: GSVCLabel!
    @IBOutlet weak var txtAmount: GSVCTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setUpToolBar()
        btnEdit.setTitleColor(UIColor.GSVCPrincipal100, for: .normal)
        txtAmount.delegate = self
        txtAmount.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1.0).cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let hasLittleCoin = false
        if string.count == 0, txtAmount.text?.dValue ?? 0 < 0.1 {
            textField.resetAmount(withLittleCoin: hasLittleCoin)
        } else {
            let bHideCents = GSSISessionInfo.sharedInstance.bHideCents
            textField.addText(newText: string,
                              withMaxFontSize: 80,
                              withLittleCoin: hasLittleCoin, withFontWeight: .bold,
                              withNoDecimals: bHideCents)
        }
        return false
    }
    
    func setUpToolBar(){
        let buttonOne = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelNumberPad))
        buttonOne.tintColor = .white
        
        let buttonTwo =  UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(doneWithNumberPad))
        buttonTwo.tintColor = .white
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.backgroundColor = UIColor(red: 19/255, green: 49/255, blue: 219/255, alpha: 1.0)
        numberToolbar.barTintColor = UIColor.GSVCSecundary100
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), buttonOne, buttonTwo]
        numberToolbar.sizeToFit()
        txtAmount.inputAccessoryView = numberToolbar
    }
    
    @objc func cancelNumberPad() {
        btnEdit.isHidden = false
        lblSubtitle.isHidden = false
        txtAmount.isHidden = true
        self.endEditing(true)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BASALimitCellEditFinished"), object: nil, userInfo: nil))
    }
    
    @objc func doneWithNumberPad() {
        self.endEditing(true)
        btnEdit.isHidden = false
        lblSubtitle.isHidden = false
        txtAmount.isHidden = true
        lblSubtitle.text = "Hasta " + txtAmount.text!
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BASALimitCellEditFinished"), object: nil, userInfo: nil))
    }
    
    @IBAction func beginEdit(sender: GSVCButton){
        lblSubtitle.isHidden = true
        btnEdit.isHidden = true
        txtAmount.isHidden = false
    }
}

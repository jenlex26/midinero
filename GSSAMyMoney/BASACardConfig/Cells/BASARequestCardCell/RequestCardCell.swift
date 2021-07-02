//
//  RequestCardCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class RequestCardCell: UITableViewCell {

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var cellButton: UIButton!
    
    var cellViewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        buttonView.layer.cornerRadius = 10
        buttonView.layer.masksToBounds = true
    }
    
    @IBAction func show(_ sender: Any){
        cellViewController.navigationController?.pushViewController(BASADigitalCardRouter.createModule(userBalance: "$1,500"), animated: true)
    }
}

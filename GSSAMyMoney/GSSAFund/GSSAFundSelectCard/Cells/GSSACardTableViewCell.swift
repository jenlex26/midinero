//
//  CardTableViewCell.swift
//  GSSAMyMoney
//
//  Created by Usuario Phinder 2021 on 03/08/21.
//

import UIKit
import baz_ios_sdk_link_pago

class GSSACardTableViewCell: UITableViewCell {

    //MARK: - @IBOutlets
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var accountLabel: UILabel!
    
    //MARK: - Properties
    static let cellIdentifier = "GSSACardTableViewCell"
    private var onDelete: ((_ token: String) -> Void)?
    private var onSelect: ((_ token: String) -> Void)?
    private var token: String?
    
    static var nib: UINib {
        return UINib.init(nibName: identifier, bundle: Bundle.init(for: GSSACardTableViewCell.self))
    }
    
    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setView()
    }
    
    //MARK: - Methods
    private func setView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickCard))
        cardContainer.addGestureRecognizer(tapGesture)
        self.selectionStyle = .none
    }
    
    func setupData(token: String, bankType: String, accountNumber: String, onSelect: @escaping ((_ token: String) -> Void), onDelete: @escaping ((_ token: String) -> Void)) {
        
        self.onDelete = onDelete
        self.onSelect = onSelect
        self.token = token
        
        accountLabel.text = accountNumber
        cardTypeLabel.text = bankType
    }
    
    //MARK: - Actions
    @objc
    private func onClickCard() {
        guard let token = token else { return }
        onSelect?(token)
    }
    
    //MARK: - @IBActions
    @IBAction func onClickDelete(_ sender: Any) {
        guard let token = token else { return }
        
        self.onDelete?(token)
    }
}

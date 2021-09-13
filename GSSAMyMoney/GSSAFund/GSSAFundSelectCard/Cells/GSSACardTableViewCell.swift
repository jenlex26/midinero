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
    private var onDelete: ((_ card: LNKPG_ListCardResponseFacade.__Tokens) -> Void)?
    private var onSelect: ((_ card: LNKPG_ListCardResponseFacade.__Tokens) -> Void)?
    private var card: LNKPG_ListCardResponseFacade.__Tokens?
    
    static let cellIdentifier: String = "GSSACardTableViewCell"
    static let nib: UINib  = {
        return UINib.init(nibName: identifier, bundle: Bundle.init(for: GSSACardTableViewCell.self))
    }()
    
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
    
    func setupData(card: LNKPG_ListCardResponseFacade.__Tokens, bankType: String, accountNumber: String, onSelect: @escaping ((_ card: LNKPG_ListCardResponseFacade.__Tokens) -> Void), onDelete: @escaping ((_ card: LNKPG_ListCardResponseFacade.__Tokens) -> Void)) {
        
        self.onDelete = onDelete
        self.onSelect = onSelect
        self.card = card
        
        accountLabel.text = accountNumber
        cardTypeLabel.text = bankType
    }
    
    //MARK: - Actions
    @objc
    private func onClickCard() {
        guard let card = card else { return }
        onSelect?(card)
    }
    
    //MARK: - @IBActions
    @IBAction func onClickDelete(_ sender: Any) {
        guard let card = card else { return }
        
        self.onDelete?(card)
    }
}

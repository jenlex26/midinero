//
//  GSSACardInfo.swift
//  GSSAMyMoney
//
//  Created by Usuario Phinder 2021 on 02/08/21.
//

import Foundation
import UIKit
import GSSAVisualComponents

class GSSACardInfoView: UIView {
    //MARK: - Properties
    var acronymLabel: GSVCLabel = {
        var label = GSVCLabel()
        
        label.styleType = 1
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        
        return label
    }()
    
    var infoStack: UIStackView = {
        var stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 3
        stack.distribution = .fillEqually
        
        return stack
    }()
    var nameLabel: GSVCLabel = {
        var label = GSVCLabel()
        
        label.styleType = 8
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    var bankLabel: GSVCLabel = {
        var label = GSVCLabel()
        
        label.styleType = 8
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    var accountLabel: GSVCLabel = {
        var label = GSVCLabel()
         
        label.styleType = 8
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConstraints()
    }
    
    //MARK: - Methods
    func setupInfo(name: String, bankName: String, accountNumber: String){
        nameLabel.text = name
        bankLabel.text = accountNumber.first == "4" ? "Visa" : accountNumber.first == "5" ? "Mastercard" : "000"
        accountLabel.text = accountNumber.maskedAccount
        acronymLabel.text = getAcronymFromName(name: name)
    }
}

//MARK: - Private Functions
extension GSSACardInfoView {

    private func setupConstraints(){
        self.addSubview(acronymLabel)
        self.addSubview(infoStack)
        
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            infoStack.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: infoStack.trailingAnchor, constant: 0)
        ])
        
        acronymLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStack.leadingAnchor.constraint(equalTo: acronymLabel.trailingAnchor, constant: 8),
            acronymLabel.widthAnchor.constraint(equalToConstant: 50),
            acronymLabel.topAnchor.constraint(equalTo: infoStack.topAnchor, constant: 8),
            acronymLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(bankLabel)
        infoStack.addArrangedSubview(accountLabel)
    }
    
    private func getAcronymFromName(name: String) -> String{
        var finalString = String()
        var words = name.components(separatedBy: .whitespacesAndNewlines)
        
        if let firstCharacter = words.first?.first {
          finalString.append(String(firstCharacter))
          words.removeFirst()
        }
        if let lastCharacter = words.last?.first {
          finalString.append(String(lastCharacter))
        }
        return finalString.uppercased()
    }
    
}

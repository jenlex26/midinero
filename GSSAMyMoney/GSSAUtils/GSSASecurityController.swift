//
//  GSSASecurityController.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 26/06/21.
//

import Foundation
import UIKit
import GSSASecurityManager
import GSSASessionInfo

extension String{
    func dynamicEncrypt() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.dynamicAlgorithm(field: self, task: .encrypted) else {
            return self
        }
        return result
    }
    
    func hybridEncrypt() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.hybrid(field: self, task: .encrypted)  else {
            return self
        }
        return result
    }
    
    func encryptAlnova() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.alnovaAlgorithm(field: self, task: .encrypted) else {
            return self
        }
        return result
    }
    
    func dynamicDecrypt() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.dynamicAlgorithm(field: self, task: .decrypted) else {
            return self
        }
        
        return result
    }
    
    func alnovaDecrypt() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.alnovaAlgorithm(field: self, task: .decrypted) else {
            return self
        }
        
        return result
    }
    
    func hybridDecrypt() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.hybrid(field: self, task: .decrypted) else {
            return self
        }
        
        return result
    }
    
    func isValidCreditCard() -> Bool{
        if self.showOnlyNumbers.count == 16 && self.count == 16{
            for item in myMoneyFrameworkSettings.shared.acceptedCardBins{
                if self.prefix(6).description == item.BIN{
                    for segment in item.segments{
                        if self.prefix(8).description == (item.BIN + segment){
                            return true
                        }
                    }
                    return false
                }
            }
            return false
        }else{
            return false
        }
    }
}

extension UIViewController{
    func parseAccounts(accounts: [[String: Any]]) {
        if let account = accounts.first {
            var mapAccount: [String: Any] = [:]
            let serviceSecurity = GSSAServiceSecurity()
            if let card = account["numeroTarjeta"] as? String,
               let result = serviceSecurity.alnovaAlgorithm(field: card, task: .decrypted) {
                mapAccount["card"] = result
                GSSISessionInfo.sharedInstance.gsUser.updateInfo(info: ["card": result])
            }
            if let account = account["numero"] as? String,
               let result = serviceSecurity.alnovaAlgorithm(field: account, task: .decrypted) {
                mapAccount["number"] = result
                GSSISessionInfo.sharedInstance.gsUser.updateInfo(info: ["mainAccount": result])
            }
            if let product = account["idProducto"] as? String {
                mapAccount["productId"] = product
            }
            if let subProduct = account["idSubProducto"] as? String {
                mapAccount["subproductId"] = subProduct
            }
            if let clabe = account["clabe"] as? String,
               let result = serviceSecurity.alnovaAlgorithm(field: clabe, task: .decrypted) {
                mapAccount["clabe"] = result
            }
            if let balance = account["saldoTotal"] as? String,
               let result = serviceSecurity.alnovaAlgorithm(field: balance, task: .decrypted) {
                mapAccount["totalBalance"] = result
            }
            if let balance = account["saldoDisponible"] as? String,
               let result = serviceSecurity.alnovaAlgorithm(field: balance, task: .decrypted) {
                let balanceDouble = Double(result) ?? 0.0
                
                mapAccount["availableBalance"] = balanceDouble
            }
            
            GSSISessionInfo.sharedInstance.gsUser.updateInfo(info: ["account": mapAccount])
        }
    }
    
    func getCompleteUserName() -> String{
        var name = ""
        name = "\(GSSISessionInfo.sharedInstance.gsUser.name ?? "") \(GSSISessionInfo.sharedInstance.gsUser.lastName ?? "") \(GSSISessionInfo.sharedInstance.gsUser.secondLastName ?? "")"
        return name
    }
}

//
//  GSSASecurityController.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 26/06/21.
//

import Foundation
import GSSASecurityManager

extension String{
    func dynamicEncrypt() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.dynamicAlgorithm(field: self, task: .encrypted) else {
            return "Encryption error"
        }
        return result
    }
    
    func encryptAlnova() -> String{
        let serviceSecurity = GSSAServiceSecurity()
        guard let result = serviceSecurity.alnovaAlgorithm(field: self, task: .encrypted) else {
            return "Encryption error"
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
}

//
//  GSSAVersionSettings.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez  on 11/10/21.
//

import Foundation

public struct myMoneyFrameworkSettings{
    static var shared = myMoneyFrameworkSettings()
    var showCredit                  : Bool = true
    var checkuserActivations          : Bool = false //Shows physical debit card flow (request, activate, turn on/off) in settings screen, even if firebase flag is set on false
    var enableEasterEgg             : Bool = true
    var showCreditCardControlSettings: Bool = false
    private init() { }
}

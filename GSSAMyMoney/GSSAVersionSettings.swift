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
    var showPINinUserActivarions : Bool = false
    var enableEasterEgg             : Bool = true
    var showCreditCardControlSettings: Bool = false
    var acceptedCardBins: [BINS] = [BINS.init(BIN: "458909", segments: ["03","06","04"]), BINS.init(BIN: "516583", segments: ["03","06","09"])]
    private init() {}
}

struct BINS{
    var BIN: String
    var segments: [String]
}

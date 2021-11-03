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
    var showPINinUserActivarions    : Bool = false
    var enableEasterEgg            : Bool = true
    var showCreditCardControlSettings: Bool = false
    var showV2SPEIDetail         : Bool = true
    var showOfflineWallet      : Bool = false
    var acceptedCardBins: [BINS] = [BINS.init(BIN: "458909", segments: ["03","06","04"]), BINS.init(BIN: "516583", segments: ["03","06","09"])]
    private init() {}
}

public struct customToken{
    static var shared = customToken()
    var bearer = "eyJraWQiOiJkczdRNlBTbE9ZNStuMnJjXC9PdjJqTGp5eWZRS2VJdmFjRXcwWHlNQm80cz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxOGg4dmFudnJoNHB1aTFscm50YzFuaWxqZiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiVXN1YXJpb1wvZGVsZXRlIFVzdWFyaW9cL3JlYWQgVXN1YXJpb1wvdXBkYXRlIiwiYXV0aF90aW1lIjoxNjI5Mzg0OTc4LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9FaEZuSU9JRzAiLCJleHAiOjE2MjkzODg1NzgsImlhdCI6MTYyOTM4NDk3OCwidmVyc2lvbiI6MiwianRpIjoiM2EyODEwMjktMjM5NC00MDFjLTllYWYtZWQzNWM3OGY3MzBlIiwiY2xpZW50X2lkIjoiMThoOHZhbnZyaDRwdWkxbHJudGMxbmlsamYifQ.DaNOE6L-4x5_VmvgSRPMdThF5fvFQQ-efwraTW0N-6_otaZzl44MNofPpBJSWErHKKFW3INrfuS_QqfPmNYQKudI3jH0JRJ3E1fy-5mS4d4WdHgJJQe4X33H8pihRsvdCM7gbwdEfcZZU7Vq-N3ybFK206KCFijtikECqbsapR3QwVa4jASTnaruvUvHqaJh1BmDqK4-i_X22TrNq1uRDYAqCyu1b5I7lHhbLFv-XAT48GF6cRJhR97kQXqvJ3lvfOs_eCA0Xvs_-AQ5fe05kT5A_3aLrVkedXB6e0WXsHvHPU3pR3JQhIOHMWBqBOMF_JJHISEWiMTbM2jbmZyZ8A"
    var firstVerification = "fac2ac44565db5312fb407c3c9482d04"
    var contractNumber = ""
    var debitCardNumber = ""
    private init() { }
}

struct BINS{
    var BIN: String
    var segments: [String]
}

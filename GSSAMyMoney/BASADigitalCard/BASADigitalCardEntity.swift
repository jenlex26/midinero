//
//  BASADigitalCardEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 22/06/21.
//

import Foundation

public struct AccountResponse: Codable{
    var mensaje: String
    var folio: String
    var resultado: AccountInfo
}

public struct AccountInfo: Codable{
    var numeroCuenta: Int
    var numeroTarjeta: Int
    var cvv: Int
    var fechaExpiracion: String
}

public struct AccoutRequest: Codable{
    var numeroCuenta: Int
    var token: Int
    var primerTokenVerificacion: String
}

public struct Transaction: Codable{
    var transaccion: AccoutRequest
}

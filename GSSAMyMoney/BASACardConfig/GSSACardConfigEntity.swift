//
//  GSSACardConfigEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 10/08/21.
//

import Foundation

// MARK: - CardConfigCardSearchBody
struct CardConfigCardSearchBody: Codable {
    var transaccion: CardConfigCardSearchTransaccion?
}

// MARK: - Transaccion
struct CardConfigCardSearchTransaccion: Codable {
    var primerTokenVerificacion, sicu, numeroCuenta, idTipoTarjeta: String?
}

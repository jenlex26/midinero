//
//  GSDigitalCardEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 09/07/21.
//

import Foundation

// MARK: - CardStateBody
struct CardStateBody: Codable {
    var transaccion: CardStateTransaccion?
}

// MARK: - Transaccion
struct CardStateTransaccion: Codable {
    var primerTokenVerificacion, numeroTarjeta: String?
    var estatus: Bool?
}

//
//  GSSACardLimitsEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 08/07/21.
//

import Foundation

// MARK: - CardLimitsBody
struct CardLimitsBody: Codable {
    var transaccion:  CardLimitsTransaccion?
}

// MARK: - Transaccion
struct  CardLimitsTransaccion: Codable {
    var primerTokenVerificacion, numeroTarjeta, monto, indicadorLimite: String?
}

// MARK: - CardLimitsResponse
struct CardLimitsResponse: Codable {
    var mensaje, folio: String?
}


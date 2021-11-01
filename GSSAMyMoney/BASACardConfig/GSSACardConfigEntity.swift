//
//  GSSACardConfigEntity.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 10/08/21.
//

import Foundation

// MARK: - CardConfigCardSearchBody
struct CardConfigCardSearchBody: Codable {
    var transaccion: CardConfigCardSearchTransaccion?
}

// MARK: - CardConfigCard Transaccion
struct CardConfigCardSearchTransaccion: Codable {
    var idTipoTarjeta, numeroCuenta, primerTokenVerificacion : String?
}

// MARK: - CardStatusResponse
struct CardStatusResponse: Codable {
    var mensaje, folio: String?
    var resultado: CardStatusResponseResult?
}

// MARK: - Resultado
struct CardStatusResponseResult: Codable {
    var idCliente: String?
    var tarjeta: CardStatusCard?
}

// MARK: - Tarjeta
struct CardStatusCard: Codable {
    var tipo, fechaRegistro, estatus, numeroGuia: String?
}

// MARK: - CardConfigCardInfo Body
struct CardConfigCardInfoBody: Codable {
    var transaccion: CardConfigCardInfoTransaccion?
}

// MARK: - CardConfigCardInfo Transaccion
struct CardConfigCardInfoTransaccion: Codable {
    var numeroCuenta, primerTokenVerificacion : String?
}

// MARK: - DebitCardInfoResponse
struct DebitCardInfoResponse: Codable {
    var mensaje, folio: String?
    var resultado: DebitCardInfoResult?
}

// MARK: - Resultado
struct DebitCardInfoResult: Codable {
    var numeroTarjeta, tipo, valorTipo, estatus: String?
    var fechaExpiracion: String?
}

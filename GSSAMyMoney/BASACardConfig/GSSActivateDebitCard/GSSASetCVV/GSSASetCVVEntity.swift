//
//  GSSASetCVVEntity.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 12/08/21.
//

import Foundation

// MARK: - SetCVVBody
struct SetCVVBody: Codable {
    var transaccion: SetCVVTransaccion?
}

// MARK: - Transaccion
struct SetCVVTransaccion: Codable {
    var primerTokenVerificacion, idTipoParticipante: String?
    var cuenta: SetCVVAccount?
    var tarjeta: Tarjeta?
}

// MARK: - Cuenta
struct SetCVVAccount: Codable {
    var numero, idProducto, idSubproducto: String?
}

// MARK: - Tarjeta
struct Tarjeta: Codable {
    var numero, cvv: String?
}

// MARK: - CreditCardActivationResponse
struct CreditCardActivationResponse: Codable {
    var mensaje, folio: String?
    var resultado: CreditCardActivationResult?
}

// MARK: - Resultado
struct CreditCardActivationResult: Codable {
    var fechaExpiracion: String?
}

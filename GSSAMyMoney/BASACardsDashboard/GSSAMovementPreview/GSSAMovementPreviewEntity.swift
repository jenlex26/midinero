//
//  GSSAMovementPreviewEntity.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 13/07/21.
//

import Foundation

// MARK: - SPEIDetailBody
struct SPEIDetailBody: Codable {
    var transaccion: SPEIDetailTransaccion?
}

// MARK: - Transaccion
struct SPEIDetailTransaccion: Codable {
    var claveInstitucionBancaria: String?
    var operacion: SPEIDetailOperacion?
}

// MARK: - Operacion
struct SPEIDetailOperacion: Codable {
    var tipo, fecha, hora: String?
}


public struct SPEIDetailResponse: Codable{
    var transaccion: SPEIDetailTransactionResponse?
}

// MARK: - SPEIDetailTransaction
struct SPEIDetailTransactionResponse: Codable {
    var mensaje, folio: String?
    var resultado: SPEIDetailTransactionResult?
}

// MARK: - Resultado
struct SPEIDetailTransactionResult: Codable {
    var numeroCuentaOrigen, importeBeneficiario, nombreBeneficiario, estatusTransferencia: String?
    var urlEstatusTransferencia: String?
}

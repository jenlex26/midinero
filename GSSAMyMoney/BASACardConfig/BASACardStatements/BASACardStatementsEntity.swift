//
//  BASACardStatementsEntity.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 23/06/21.
//

import Foundation

// MARK: - DebitCardBody
struct DebitCardStatementBody: Codable {
    let numeroCuenta, fechaInicio, fechaFin: String?
}

// MARK: - DebitCardStatement
struct DebitCardStatementData: Codable {
    var mensaje, folio: String?
    var resultado: StatementResult?
}


// MARK: - DebitCardResultado
struct StatementResult: Codable {
    var numeroCuenta: String?
    var detalles: [StatementDetail]?
}


// MARK: - DebitCardDetalle
struct StatementDetail: Codable {
    var periodo, fechaInicio, fechaFin: String?
}


// MARK: - Transaccion
struct RequestDocumentBody: Codable {
    let primerTokenVerificacion, referencia, periodo: String
}


// MARK: - RequestDocumentResponse
struct RequestDocumentResponse: Codable {
    var mensaje, folio: String?
    var resultado: RequestDocumentResult?
}

// MARK: -  RequestDocumentResult
struct RequestDocumentResult: Codable {
    var documento: String?
}

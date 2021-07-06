//
//  GSSAMainHubCreditEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 05/07/21.
//

import Foundation

// MARK: - CreditCardBody
struct CreditCardBody: Codable {
    var transaccion: CreditCardTransaccion?
}

// MARK: - CreditCard Transaccion
struct CreditCardTransaccion: Codable {
    var numeroCuenta, numeroTarjeta, numeroContrato: String?
}

// MARK: - CreditCardResponse
struct CreditCardResponse: Codable {
    var mensaje, folio: String?
    var resultado: CreditCardResult?
}

// MARK: - CreditCard Resultado
struct CreditCardResult: Codable {
    var tarjetas: [ CreditCardItem]?
}

// MARK: - Tarjeta de Credito
struct CreditCardItem: Codable {
    var numero, nombreCliente, expiracion, tipo: String?
    var estatus: String?
}

// MARK: - CreditCardBalanceBody
struct CreditCardBalanceBody: Codable {
    var transaccion: CreditCardBalanceTransaccion?
}

// MARK: - CreditCardBalanceTransaccion
struct CreditCardBalanceTransaccion: Codable {
    var numeroTarjeta: String?
}

// MARK: - CreditCardBalanceResponse
struct CreditCardBalanceResponse: Codable {
    var mensaje, folio: String?
    var resultado: CreditCardBalanceResult?
}

// MARK: - CreditCard Resultado
struct CreditCardBalanceResult: Codable {
    var saldo, saldoActual, saldoDisponible, saldoDispuesto: String?
    var saldoRetenido, fechaCorte, montoLimiteCredito, pagoSinInteres: String?
    var montoPagoMinimo, fechaPago: String?
}

// MARK: - CreditCardMovementsBody
struct CreditCardMovementsBody: Codable {
    var transaccion: CreditCardMovementsTransaccion?
}

// MARK: - CreditCardMovementsTransaccion
struct CreditCardMovementsTransaccion: Codable {
    var fechaInicio, fechaFin: String?
}

// MARK: - CreditCardMovementsResponse
struct CreditCardMovementsResponse: Codable {
    var mensaje, folio: String?
    var resultado: CreditCardMovementsResult?
}

// MARK: - CreditCardMovementsResult
struct CreditCardMovementsResult: Codable {
    var movimientos: [CreditCardMovement]?
}

// MARK: -  Movimiento Tarjeta de crédito
struct CreditCardMovement: Codable {
    var idEstatus, idTipo, concepto, monto: String?
    var divisa, tipoDeCambio, montoOriginal, referencia: String?
    var fechaHora: String?
}


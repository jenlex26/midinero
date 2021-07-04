//
//  BASACardsdashboardEntity.swift
//  GSSAFront
//
//  Created by BranchbitG on 16/06/21.
//

import Foundation

// MARK: - Debit Account Info
struct AccountBalanceResult: Codable {
    let mensaje, folio: String
    let resultado: Resultado
}

// MARK: - Debit Account Info Resultado
struct Resultado: Codable {
    let cliente: Cliente?
}

// MARK: - Debit Account Info Cliente
struct Cliente: Codable {
    let nombre, apellidoPaterno, apellidoMaterno: String?
    let cuentas: [Cuenta]?
}

// MARK: - Debit Account Info  Cuenta
struct Cuenta: Codable {
    let alias, numero, numeroTarjeta, clabe, codigoEstatus: String?
    let saldoTotal, saldoRetenido, saldoDisponible: String?
}


// MARK: - DEBIT BALANCE
struct BalanceResult: Codable {
    let saldoDisponible, numeroOperacion, divisa, titularCuenta: String?
    let numeroCuenta, descripcionCuenta, fechaHoraOperacion: String?
}

// MARK: - DEBIT BalanceResponse
struct BalanceResponse: Codable {
    let mensaje, folio: String?
    let resultado: Resultado
}

// MARK: - DEBIT AccountBalance
struct TransationBalanceRequest: Codable {
    let transaccion: TransationItem
}

// MARK: - DEBIT Transaccion
struct TransationItem: Codable {
    let folio: String
    let numeroCuenta: String
}


// MARK: - DEBIT MOVEMENTS BODY
struct MovimientosBody: Codable {
    var transaccion: MovementsBodyData?
}

// MARK: - DEBIT MOVEMENTS BODY
struct MovementsBodyData: Codable {
    let numeroCuenta, fechaInicial, fechaFinal: String?
}

// MARK: - DebitCardTransactionData
struct DebitCardTransaction: Codable {
    let mensaje, folio: String
    let resultado: DebitCardTransactionResult
}

// MARK: - DebitCardTransactionResult
struct DebitCardTransactionResult: Codable {
    let numeroCuenta, producto, titularCuenta, fechaConsulta: String
    let horaConsulta: String
    var movimientos: [DebitCardTransactionItem]
}

// MARK: - DebitCardTransactionItem
struct DebitCardTransactionItem: Codable {
    let importe, saldo, descripcion, fechaOperacion: String?
    let numeroMovimiento, codigoDivisa: String?
}


// MARK: - LendsResponse
struct LendsResponse: Codable {
    var mensaje, folio: String?
    var resultado: LendsResponseResult?
}

// MARK: - Prestamos Resultado
struct LendsResponseResult: Codable {
    var fechaProximoPago, fechaProximoPagoDesarrollada: String?
    var pagoPuntual, pagoNormal, pagoSugerido, pagoRequerido: Int?
    var pagoLiquidar: Int?
    var productos: [LendsResponseProducts]?
}

// MARK: - Prestamos Producto
struct LendsResponseProducts: Codable {
    var id: Int?
    var descripcion, pagoPuntual, pagoNormal, pagoSugerido: String?
    var pagoLiquidar, pagoRequerido: String?
}


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

// MARK: - Movimiento
struct CreditCardMovement: Codable {
    var idEstatus, idTipo, concepto, monto: String?
    var divisa, tipoDeCambio, montoOriginal, referencia: String?
    var fechaHora: String?
}


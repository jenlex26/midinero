//
//  GSSARequestDebitCardEntity.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 09/08/21.
//

import Foundation


// MARK: - PhysicalCardCommisionBody
struct PhysicalCardShippingAmountTransaction: Codable {
    var transaccion: PhysicalCardShippingAmountBody?
}

// MARK: - PhysicalCardShippingAmountBody
struct PhysicalCardShippingAmountBody: Codable {
    var numeroTarjeta, primerTokenVerificacion: String?
    var geolocalizacion: ShippingAmountLocation?
}

// MARK: - Geolocalizacion
struct ShippingAmountLocation: Codable {
    var latitud, longitud: String?
}

// MARK: - PhysicalCardShippingAmountResponse
struct PhysicalCardShippingAmountResponse: Codable {
    var mensaje, folio: String?
    var resultado: PhysicalCardShippingAmountResult?
}

// MARK: - Resultado
struct PhysicalCardShippingAmountResult: Codable {
    var montoComision, montoIVA, montoTotal: String?
}


// MARK: - ConfirmCardRequestBody
struct ConfirmCardRequestBody: Codable {
    var transaccion: ConfirmCardRequestTransaccion?
}

// MARK: - Transaccion
struct ConfirmCardRequestTransaccion: Codable {
    var numeroCuenta, primerTokenVerificacion: String?
    var envio: Envio?
}

// MARK: - Envio
struct Envio: Codable {
    var idTipoTarjeta: String?
    var cliente: ConfirmCardRequestTransaccionClient?
    var comision: String?
    var domicilio: Domicilio?
}

// MARK: - Cliente
struct ConfirmCardRequestTransaccionClient: Codable {
    var nombre, numeroTelefonico: String?
}

// MARK: - Domicilio
struct Domicilio: Codable {
    var ciudad, colonia, numeroExterior, numeroInterior: String?
    var codigoPostal, calle: String?
}




//
//  GSSARequestDebitCardEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 09/08/21.
//

import Foundation

// MARK: - PhysicalCardCommisionBody
struct PhysicalCardCommisionBody: Codable {
    var transaccion: PhysicalCardCommisionTransaction?
}

// MARK: - PhysicalCardCommisionTransaction
struct PhysicalCardCommisionTransaction: Codable {
    var geolocalizacion: ShippingAmountLocation?
    var numeroTarjeta, primerTokenVerificacion: String
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
    var monto: String?
}








// MARK: - ConfirmCardRequestBody
struct ConfirmCardRequestBody: Codable {
    var transaccion: ConfirmCardRequestTransaccion?
}

// MARK: - Transaccion
struct ConfirmCardRequestTransaccion: Codable {
    var primerTokenVerificacion, sicu, numeroCuenta: String?
    var envio: Envio?
}

// MARK: - Envio
struct Envio: Codable {
    var comision, idTipoTarjeta: String?
    var cliente: ConfirmCardRequestTransaccionClient?
    var domicilio: Domicilio?
}

// MARK: - Cliente
struct ConfirmCardRequestTransaccionClient: Codable {
    var nombre, numeroTelefonico: String?
}

// MARK: - Domicilio
struct Domicilio: Codable {
    var ciudad, calle, colonia, codigoPostal: String?
    var numeroExterior, numeroInterior: String?
}

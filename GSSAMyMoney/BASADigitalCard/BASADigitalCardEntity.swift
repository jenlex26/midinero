//
//  BASADigitalCardEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 22/06/21.
//

import Foundation


// MARK: - DigitalCardResponse
struct DigitalCardResponse: Codable {
    var mensaje, folio: String?
    var resultado: DigitalCardResult?
}

// MARK: - Resultado
struct DigitalCardResult: Codable {
    var numeroContrato, codigoMoneda, codigoComisionPlan, descripcionComision: String?
    var identificadorClave, valorEstatus, valorDisposicion, estatusDisposicion: String?
    var disposicion: String?
    var participante: DigitalCardParticipant?
    var tarjeta: DigitalCardData?
    var monto: DigitalCardAmount?
    var limite: DigitalCardLimit?
}

// MARK: - Limite
struct  DigitalCardLimit: Codable {
    var cajeroDia, zonaDia, credito, dispositivoDia: String?
    var cajeroMes: String?
}

// MARK: - Monto
struct  DigitalCardAmount: Codable {
    var credito, limiteCredito, autorizadoCredito, disponible: String?
    var autorizado, total: String?
}

// MARK: - Participante
struct  DigitalCardParticipant: Codable {
    var nombre, clave, secuencia: String?
}

// MARK: - Tarjeta
struct  DigitalCardData: Codable {
    var numero, tipo, valorTipo, estatus: String?
    var fechaExpiracion, cvv: String?
}


public struct AccoutRequest: Codable{
    var numeroCuenta: String?
}

public struct Transaction: Codable{
    var transaccion: AccoutRequest
}

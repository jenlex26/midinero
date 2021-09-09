//
//  GSSACardConfigEntity.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 10/08/21.
//

import Foundation

public struct customToken{
    static var shared = customToken()
    var bearer = "eyJraWQiOiJkczdRNlBTbE9ZNStuMnJjXC9PdjJqTGp5eWZRS2VJdmFjRXcwWHlNQm80cz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxOGg4dmFudnJoNHB1aTFscm50YzFuaWxqZiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiVXN1YXJpb1wvZGVsZXRlIFVzdWFyaW9cL3JlYWQgVXN1YXJpb1wvdXBkYXRlIiwiYXV0aF90aW1lIjoxNjI5Mzg0OTc4LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9FaEZuSU9JRzAiLCJleHAiOjE2MjkzODg1NzgsImlhdCI6MTYyOTM4NDk3OCwidmVyc2lvbiI6MiwianRpIjoiM2EyODEwMjktMjM5NC00MDFjLTllYWYtZWQzNWM3OGY3MzBlIiwiY2xpZW50X2lkIjoiMThoOHZhbnZyaDRwdWkxbHJudGMxbmlsamYifQ.DaNOE6L-4x5_VmvgSRPMdThF5fvFQQ-efwraTW0N-6_otaZzl44MNofPpBJSWErHKKFW3INrfuS_QqfPmNYQKudI3jH0JRJ3E1fy-5mS4d4WdHgJJQe4X33H8pihRsvdCM7gbwdEfcZZU7Vq-N3ybFK206KCFijtikECqbsapR3QwVa4jASTnaruvUvHqaJh1BmDqK4-i_X22TrNq1uRDYAqCyu1b5I7lHhbLFv-XAT48GF6cRJhR97kQXqvJ3lvfOs_eCA0Xvs_-AQ5fe05kT5A_3aLrVkedXB6e0WXsHvHPU3pR3JQhIOHMWBqBOMF_JJHISEWiMTbM2jbmZyZ8A"
    var firstVerification = "fac2ac44565db5312fb407c3c9482d04"
    private init() { }
}

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

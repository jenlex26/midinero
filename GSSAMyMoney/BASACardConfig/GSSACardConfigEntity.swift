//
//  GSSACardConfigEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 10/08/21.
//

import Foundation


public struct customToken{
    static var shared = customToken()
    var bearer = "eyJraWQiOiJkczdRNlBTbE9ZNStuMnJjXC9PdjJqTGp5eWZRS2VJdmFjRXcwWHlNQm80cz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxOGg4dmFudnJoNHB1aTFscm50YzFuaWxqZiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiVXN1YXJpb1wvZGVsZXRlIFVzdWFyaW9cL3JlYWQgVXN1YXJpb1wvdXBkYXRlIiwiYXV0aF90aW1lIjoxNjI5MTQ4MjM3LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9FaEZuSU9JRzAiLCJleHAiOjE2MjkxNTE4MzcsImlhdCI6MTYyOTE0ODIzNywidmVyc2lvbiI6MiwianRpIjoiNTYxNzc5MzMtNTRjMy00NDMxLWE0ZDctZTAyNzkzMjZjYmYwIiwiY2xpZW50X2lkIjoiMThoOHZhbnZyaDRwdWkxbHJudGMxbmlsamYifQ.kBeVCtTBG2WaEsQPe44wP5dKxK49phBXvByfl9KaDv-85WUgoMExd5rRivgvsXgU4aIai3_IJKt2w8DDWZgjZClCUehIx0qPf52JiHFXWE0agS11NGyF6mY9_y3tBrhgwOSJI-55MvWGoO-RfjiQuCXa-3WuA6UcDoxKzDnJNcoDBKfa0tFhPinZEdHqF-noJvlxbouXlkwmrkAogCyzB_Om34R4_oxKUJZQ8yA4afTrRA5kAwcoYrvaaV5hYR57fcjWW7Q6RVARsyUDIw6abN3OcsZ3SRHjXuemBv8ccNFePp3Tjfns-Wtabj4CIc-QGnFuJQG2c-zbPaB3PsWw1A"
    private init() { }
}


// MARK: - CardConfigCardSearchBody
struct CardConfigCardSearchBody: Codable {
    var transaccion: CardConfigCardSearchTransaccion?
}

// MARK: - Transaccion
struct CardConfigCardSearchTransaccion: Codable {
    var primerTokenVerificacion, sicu, numeroCuenta, idTipoTarjeta: String?
}

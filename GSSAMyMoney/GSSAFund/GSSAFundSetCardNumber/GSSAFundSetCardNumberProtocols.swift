//
//  GSSAFundSetCardNumberProtocols.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 02/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

//MARK: Wireframe -
protocol GSSAFundSetCardNumberWireframeProtocol: AnyObject {
    func goToAddAddress(_ view: UIViewController)
    func goBack()
}

//MARK: Presenter -
protocol GSSAFundSetCardNumberPresenterProtocol: AnyObject {
    func checkTextFields(cardNumber: String?, expiration: String?, cvv: String?)
    func areTextFieldsCorrect(cardNumber: String, expiration: String, cvv: String)
    func cardNumberIsEmpty(_ isEmpty: Bool)
    func expirationIsEmpty(_ isEmpty: Bool)
    func cvvIsEmpty(_ isEmpty: Bool)
    
    func goToAddAddress(_ view: UIViewController)
    func goBack()
}

//MARK: Interactor -
protocol GSSAFundSetCardNumberInteractorProtocol: AnyObject {
    
    var presenter: GSSAFundSetCardNumberPresenterProtocol?  { get set }
    
    func checkTextFields(cardNumber: String?, expiration: String?, cvv: String?)
}

//MARK: View -
protocol GSSAFundSetCardNumberViewProtocol: AnyObject {
    
    var presenter: GSSAFundSetCardNumberPresenterProtocol?  { get set }
    
    func areTextFieldsCorrect(cardNumber: String, expiration: String, cvv: String)
    func cardNumberIsEmpty(_ isEmpty: Bool)
    func expirationIsEmpty(_ isEmpty: Bool)
    func cvvIsEmpty(_ isEmpty: Bool)
}

//
//  GSSAFundSelectCardProtocols.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 02/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import baz_ios_sdk_link_pago

//MARK: Wireframe -
protocol GSSAFundSelectCardWireframeProtocol: AnyObject {
    func goToValidateCVV(_ view: UIViewController)
    func goToAddNewCard(_ view: UIViewController)
    func showError(_ view: UIViewController)
    func showAlert(_ view: UIViewController)
}

//MARK: Presenter -
protocol GSSAFundSelectCardPresenterProtocol: AnyObject {
    func getEccomerceInformation()
    func getEccomerceInformationSuccess()
    func getEccomerceInformationError()
    
    func getCards()
    func getCardsSuccess(cards: [LNKPG_ListCardResponseFacade.__Tokens])
    func getCardsError()
    
    func deleteCard(body request: LNKPG_TokenCardDeleteRequestFacade)
    func deleteCardSuccess(response: LNKPG_TokenCardDeleteResponseFacade)
    func deleteCardError()
    
    func goToValidateCVV(_ view: UIViewController)
    func goToAddNewCard(_ view: UIViewController)
    func showError(_ view: UIViewController)
    func showAlert(_ view: UIViewController)
}

//MARK: Interactor -
protocol GSSAFundSelectCardInteractorProtocol: AnyObject {
    
    var presenter: GSSAFundSelectCardPresenterProtocol?  { get set }
    
    func deleteCard(body request: LNKPG_TokenCardDeleteRequestFacade)
    func getCards()
    func getEccomerceInformation()
}

//MARK: View -
protocol GSSAFundSelectCardViewProtocol: AnyObject {
    
    var presenter: GSSAFundSelectCardPresenterProtocol?  { get set }
    
    func getCardsSuccess(cards: [LNKPG_ListCardResponseFacade.__Tokens])
    func getCardsError()
    
    func deleteCardSuccess(response: LNKPG_TokenCardDeleteResponseFacade)
    func deleteCardError()
    
    func getEccomerceInformationSuccess()
    func getEccomerceInformationError()
}

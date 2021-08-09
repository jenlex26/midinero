//
//  GSSARequestDebitCardProtocols.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 28/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol GSSARequestDebitCardWireframeProtocol: AnyObject {

}
//MARK: Presenter -
protocol GSSARequestDebitCardPresenterProtocol: AnyObject {
    func requestGetShippingCost(Response: @escaping (PhysicalCardShippingAmountResponse?) -> ())
}

//MARK: Interactor -
protocol GSSARequestDebitCardInteractorProtocol: AnyObject {
  var presenter: GSSARequestDebitCardPresenterProtocol?  { get set }
    func tryGetShippingCost(Response: @escaping (PhysicalCardShippingAmountResponse?) -> ())
}

//MARK: View -
protocol GSSARequestDebitCardViewProtocol: AnyObject {
  var presenter: GSSARequestDebitCardPresenterProtocol?  { get set }
}

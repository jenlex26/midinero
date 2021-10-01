//
//  GSSACardPaymentBtnSliderViewProtocols.swift
//  GSSAMyMoney
//
//  Created cvillegasa on 07/09/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol GSSACardPaymentBtnSliderViewWireframeProtocol: AnyObject {

}
//MARK: Presenter -
protocol GSSACardPaymentBtnSliderViewPresenterProtocol: AnyObject {
    func closeParent()
}

//MARK: Interactor -
protocol GSSACardPaymentBtnSliderViewInteractorProtocol: AnyObject {
  var presenter: GSSACardPaymentBtnSliderViewPresenterProtocol?  { get set }
}

//MARK: View -
protocol GSSACardPaymentBtnSliderViewViewProtocol: AnyObject {
  var presenter: GSSACardPaymentBtnSliderViewPresenterProtocol?  { get set }
}

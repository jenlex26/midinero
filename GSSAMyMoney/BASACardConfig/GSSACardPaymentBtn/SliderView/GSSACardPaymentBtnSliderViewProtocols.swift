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
protocol GSSACardPaymentBtnSliderViewWireframeProtocol: class {

}
//MARK: Presenter -
protocol GSSACardPaymentBtnSliderViewPresenterProtocol: class {
    func closeParent()
}

//MARK: Interactor -
protocol GSSACardPaymentBtnSliderViewInteractorProtocol: class {
  var presenter: GSSACardPaymentBtnSliderViewPresenterProtocol?  { get set }
}

//MARK: View -
protocol GSSACardPaymentBtnSliderViewViewProtocol: class {
  var presenter: GSSACardPaymentBtnSliderViewPresenterProtocol?  { get set }
}
//
//  BASACardLimitsProtocols.swift
//  GSSAFront
//
//  Created Desarrollo on 14/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol BASACardLimitsWireframeProtocol: AnyObject {

}
//MARK: Presenter -
protocol BASACardLimitsPresenterProtocol: AnyObject {
    func requestCardLimitUpdate(ammount: String, indicador: String, DataCard: @escaping (CardLimitsResponse?) -> ())
}

//MARK: Interactor -
protocol BASACardLimitsInteractorProtocol: AnyObject {

  var presenter: BASACardLimitsPresenterProtocol?  { get set }
    func tryUpdateCardLimit(ammount: String, indicador: String, DataCard: @escaping (CardLimitsResponse?) -> ())
}

//MARK: View -
protocol BASACardLimitsViewProtocol: AnyObject {

  var presenter: BASACardLimitsPresenterProtocol?  { get set }
}
 

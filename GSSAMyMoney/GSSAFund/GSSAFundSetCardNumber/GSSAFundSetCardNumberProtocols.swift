//
//  GSSAFundSetCardNumberProtocols.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 02/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol GSSAFundSetCardNumberWireframeProtocol: class {

}
//MARK: Presenter -
protocol GSSAFundSetCardNumberPresenterProtocol: class {

}

//MARK: Interactor -
protocol GSSAFundSetCardNumberInteractorProtocol: class {

  var presenter: GSSAFundSetCardNumberPresenterProtocol?  { get set }
}

//MARK: View -
protocol GSSAFundSetCardNumberViewProtocol: class {

  var presenter: GSSAFundSetCardNumberPresenterProtocol?  { get set }
}

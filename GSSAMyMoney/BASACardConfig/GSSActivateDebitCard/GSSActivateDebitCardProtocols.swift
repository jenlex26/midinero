//
//  GSSActivateDebitCardProtocols.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 29/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol GSSActivateDebitCardWireframeProtocol: class {

}
//MARK: Presenter -
protocol GSSActivateDebitCardPresenterProtocol: class {

}

//MARK: Interactor -
protocol GSSActivateDebitCardInteractorProtocol: class {

  var presenter: GSSActivateDebitCardPresenterProtocol?  { get set }
}

//MARK: View -
protocol GSSActivateDebitCardViewProtocol: class {

  var presenter: GSSActivateDebitCardPresenterProtocol?  { get set }
}
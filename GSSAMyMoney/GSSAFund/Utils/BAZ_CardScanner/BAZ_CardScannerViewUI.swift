//
//  BAZ_CardScannerViewViewUI.swift
//  baz-ios-akpago-utils
//
//  Created Jorge Cruz on 15/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import baz_ios_sdk_link_pago

// MARK: BAZ_CardScannerViewViewUI Delegate -
/// BAZ_CardScannerViewViewUI Delegate
protocol BAZ_CardScannerViewUIDelegate:class {
    func notifySuccesfulScan(barcode: BAZ_CardScannerEntity)
    func notifyDissmissView()
}

class BAZ_CardScannerViewUI: UIView/*, CardIOViewDelegate*/{
    
    weak var delegate: BAZ_CardScannerViewUIDelegate?
    
    lazy var navigationBar: UIView = {
        let navigationController = UIView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        navigationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6969681291)
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close", in: Bundle(for: BAZ_CardScannerViewUI.self), compatibleWith: nil), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self.dissmissView), for: .touchUpInside)
        navigationController.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48),
            button.widthAnchor.constraint(equalToConstant: 48),
            button.leadingAnchor.constraint(equalTo: navigationController.leadingAnchor, constant: 15),
            button.centerYAnchor.constraint(equalTo: navigationController.centerYAnchor, constant: 30),
        ])
        return navigationController
    }()
    lazy var contentView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    lazy var cardView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .Poppins_Bold_22
        label.text = "Tarjeta de Debito"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var descriptionBottomText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .Poppins_Medium_16
        label.text = "Centra y escanea tu tarjeta."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var qrContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    private lazy var scanViewIO: CardIOView = {
//        let view = CardIOView(frame: .zero)
//        view.hideCardIOLogo = true
//        view.scanInstructions = ""
////        view.delegate = self
//        view.guideColor = .GSVCSecundary100
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    lazy var continueButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.GSVCPrincipal100, for: .normal)
        button.setTitle("Ingresar Manualmente", for: .normal)
        button.titleLabel?.font = .Poppins_Bold_22
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public convenience init(
        delegate: BAZ_CardScannerViewUIDelegate){
        self.init()
        self.delegate = delegate
        setupUIElements()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    }

    fileprivate func setupUIElements() {
        self.continueButton.addTarget(self, action: #selector(self.dissmissView), for: .touchUpInside)
        self.addSubview(contentView)
        self.addSubview(navigationBar)
        self.contentView.addSubview(cardView)
        self.cardView.addSubview(qrContainer)
//        self.cardView.addSubview(scanViewIO)
        self.cardView.addSubview(titleText)
        self.cardView.addSubview(descriptionBottomText)
        self.cardView.addSubview(continueButton)
    }
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
        NSLayoutConstraint.activate([
            ///NavigationBar
            self.navigationBar.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.navigationBar.heightAnchor.constraint(equalToConstant: 90),
            ///ScrollView
            self.contentView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            ///CardView
            self.cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.cardView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),

            self.qrContainer.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.qrContainer.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.qrContainer.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.qrContainer.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor,constant: -200),
            
//            self.scanViewIO.centerYAnchor.constraint(equalTo: self.qrContainer.centerYAnchor),
//            self.scanViewIO.centerXAnchor.constraint(equalTo: self.qrContainer.centerXAnchor),
//            self.scanViewIO.heightAnchor.constraint(equalTo: self.qrContainer.heightAnchor),
//            self.scanViewIO.widthAnchor.constraint(equalTo: self.qrContainer.widthAnchor),
            
            self.titleText.topAnchor.constraint(equalTo: self.cardView.bottomAnchor,constant: 20),
            self.titleText.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30),
            self.titleText.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30),
            
            self.descriptionBottomText.topAnchor.constraint(equalTo: self.titleText.bottomAnchor,constant: 10),
            self.descriptionBottomText.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 50),
            self.descriptionBottomText.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -50),
            
            self.continueButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            self.continueButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 10),
            self.continueButton.trailingAnchor.constraint(equalTo: self.self.cardView.trailingAnchor, constant: -10),
            self.continueButton.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        if(UIScreen.main.bounds.height < 700){
            NSLayoutConstraint.activate([
                self.cardView.heightAnchor.constraint(equalToConstant: 600)
            ])
        }else{
            NSLayoutConstraint.activate([
                self.cardView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -60),
            ])
        }
    }
    
//    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
//        delegate?.notifySuccesfulScan(barcode: BAZ_CardScannerEntity(numberCard: cardInfo.cardNumber, expirationMount:String(format: "%02d", cardInfo.expiryMonth), expirationYear: String(cardInfo.expiryYear).suffix(2).lowercased()))
////        delegate?.notifyDissmissView()
//    }
    
    @objc private func dissmissView(){
        delegate?.notifyDissmissView()
    }
   
}

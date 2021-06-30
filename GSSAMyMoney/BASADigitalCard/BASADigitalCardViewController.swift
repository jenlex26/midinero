//
//  BASADigitalCardViewController.swift
//  BASAMyPaymentsScreens
//
//  Created BranchbitG on 14/05/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents

enum CardType{
    case debit
    case credit
}

class BASADigitalCardViewController: UIViewController, BASADigitalCardViewProtocol, GSVCBottomAlertHandler {
    var bottomAlert: GSVCBottomAlert?
    var presenter: BASADigitalCardPresenterProtocol?
    
    //MARK: - Outlets
    
    @IBOutlet weak var DigitalCard: BASAShadowRadiusView!
    @IBOutlet weak var TopHeaderView     : UIView!
    @IBOutlet weak var CardBackgroundView: UIView!
    @IBOutlet weak var cvvView           : UIView!
    @IBOutlet weak var CVVCodeLabel      : GSVCLabel!
    @IBOutlet weak var AvaibleMoneyLabel : GSVCLabel!
    @IBOutlet weak var CardNumberLabel   : GSVCLabel!
    @IBOutlet weak var ExpTitleLabel     : GSVCLabel!
    @IBOutlet weak var ExpDateLabel      : GSVCLabel!
    @IBOutlet weak var TimerView         : BASACircularProgressView!
    
    var userBalance: String! 
    //MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ConfigureBlurCardView()
        GSVCLoader.show(type: .native)
        self.TimerView.delegate = self
        
        
        CardBackgroundView.layer.cornerRadius = 10
        CardBackgroundView.layer.masksToBounds = true
        
        CardBackgroundView.layer.borderWidth = 0.2
        CardBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        cvvView.layer.cornerRadius = 10
        cvvView.layer.masksToBounds = true
        
        cvvView.layer.borderWidth = 0.2
        cvvView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        if userBalance != nil{
            self.AvaibleMoneyLabel.text = userBalance
        }
        
        requestCVV()
    }
    
    
    func requestCVV(){
        presenter?.makeDigitalDataRequest(Body: Transaction(transaccion: AccoutRequest(numeroCuenta: 2575284525826, tokenOperacion: 85284585966396, primerTokenVerificacion: "fac2ac44565db5312fb407c3c9482d04")), DataCard: { [self] DataCard in
            GSVCLoader.hide()
            if DataCard != nil{
                self.StartTimer()
                CVVCodeLabel.text = String(DataCard!.resultado!.cvv ?? 000)
                CardNumberLabel.text = String(DataCard!.resultado!.numeroTarjeta ?? 0).tnuoccaFormat
                ExpDateLabel.text = DataCard?.resultado?.fechaExpiracion
            }else{
                self.presentBottomAlertFullData(status: .error, message: "Ocurrió un error desconocido, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
    }
    
    func optionalAction() {
        print("Ok")
    }
    
    func ConfigureBlurCardView(){
        CardBackgroundView.blurBackground(style: .light, fallbackColor: .white)
    }
    
    func StartTimer(){
        TimerView.start(beginingValue: 90)
    }
    
    func SetGradient(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: TopHeaderView.bounds.width, height: TopHeaderView.bounds.height))
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.GSVCPrincipal100.cgColor, UIColor.GSVCPrincipal100.cgColor]
        TopHeaderView.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func copyCardNumber(_ sender: Any){
        if CardNumberLabel.text?.count ?? 0 > 0{
            UIPasteboard.general.string = CardNumberLabel.text
            self.presentBottomAlertFullData(status: .success, message: "Número de tarjeta copiado al portapapeles", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
        }
    }
    
    @IBAction func TryDismiss(_ sender: Any) {
        TimerView.end()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openConfig(_ sender: Any){
        let view = GSDigitalCardConfigRouter.createModule()
        self.navigationController?.pushViewController(view, animated: true)
    }
}

//MARK: - Extensions

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView {
    @objc func blurBackground(style: UIBlurEffect.Style, fallbackColor: UIColor) {
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.insertSubview(blurEffectView, at: 0)
        } else {
            self.backgroundColor = fallbackColor
        }
    }
}

extension BASADigitalCardViewController: TimerHandleDelegate {
    func counterUpdateTimeValue(with sender: BASACircularProgressView, newValue: Int) {
        print("Tiempo Actual \(newValue)")
    }
    
    func didStartTimer(sender: BASACircularProgressView) {
        print("Inicio tiempo")
    }
    
    func didEndTimer(sender: BASACircularProgressView) {
        print("Se acabo el tiempo")
        if self.isOnScreen{
           GSVCLoader.show(type: .native)
           requestCVV()
        }
    }
}

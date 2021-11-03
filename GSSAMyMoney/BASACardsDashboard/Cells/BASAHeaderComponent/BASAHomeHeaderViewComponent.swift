//
//  BASAHomeHeaderViewComponent.swift
//  GSSAFront
//
//  Created by Andoni Suarez on 15/06/21.
//

import UIKit
import GSSAVisualComponents
import GSSASessionInfo

class BASAHomeHeaderViewComponent: UITableViewCell {
    
    @IBOutlet weak var cardCollection           : UICollectionView!
    @IBOutlet weak var pageController           : UIPageControl!
    @IBOutlet weak var TopHeaderView            : UIView!
    @IBOutlet weak var backButton               : UIButton!
    @IBOutlet weak var lblTitle                 : UILabel!
    @IBOutlet weak var debitCardContainer       : UIView!
    @IBOutlet weak var debitButton              : GSVCButton!
    @IBOutlet weak var creditButton             : GSVCButton!
    //MARK: - DebitCard Outlets -
    @IBOutlet weak var debitCardlblBalance      : GSVCLabel!
    @IBOutlet weak var debitCardlblCardNumber   : GSVCLabel!
    @IBOutlet weak var debitCardbtnConfig       : UIButton!
    @IBOutlet weak var debitCardView            : UIView!
    @IBOutlet weak var imgHeader                : UIImageView!
    @IBOutlet weak var expDateTitle             : GSVCLabel!
    @IBOutlet weak var expDateLabel             : GSVCLabel!
    @IBOutlet weak var CVVTitle                 : GSVCLabel!
    @IBOutlet weak var CVVLabel                 : GSVCLabel!
    @IBOutlet weak var btnSelect                : UIStackView!
    
    
    var gradient = CAGradientLayer()
    var cellViewController: UIViewController!
    var data: BalanceResponse?
    var lendsData: LendsResponse?
    var creditCardData: CreditCardResponse?
    var creditCardBalance: CreditCardBalanceResponse?
    var showOnlyLendsInCredit: Bool = false
    var showDebitOptions = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        let bundle = Bundle(for: BASAHomeHeaderViewComponent.self)
        self.cardCollection.register(UINib(nibName: "BASACardCell", bundle: bundle), forCellWithReuseIdentifier: "card")
        self.cardCollection.register(UINib(nibName: "BASALendViewCVC", bundle: bundle), forCellWithReuseIdentifier: "BASALendViewCVC")
        self.cardCollection.delegate = self
        self.cardCollection.dataSource = self
        self.TopHeaderView.applyCurveToView(curvedPercent: 0.12)
        debitCardView.layer.borderColor = UIColor.lightGray.cgColor
        debitCardbtnConfig.layer.cornerRadius = debitCardbtnConfig.bounds.size.width / 2.0
        debitCardbtnConfig.clipsToBounds = true
        
        if let image:UIImage = UIImage(named: "ic_card_backgroud")  {
            self.imgHeader.image = image
        }
        
        
        if #available(iOS 13.0, *) {()}else{
            backButton.contentMode = .scaleAspectFit
            backButton.setImage(UIImage.backIcon(tint: .white), for: .normal)
        }
        
        debitCardView.layer.cornerRadius = 10
        debitCardView.layer.masksToBounds = true
        
        debitCardView.layer.borderWidth = 0.2
        debitCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards(notification:)), name: NSNotification.Name(rawValue: "reloadHeaderData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLends(notification:)), name: NSNotification.Name(rawValue: "reloadLendsData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCreditCard(notification:)), name: NSNotification.Name(rawValue: "reloadCreditCardData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCreditCardBalance(notification:)), name: NSNotification.Name(rawValue: "reloadCreditCardBalance"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setTableOnlyForLends(notification:)), name: NSNotification.Name(rawValue: "onlyLendsAvaliable"), object: nil)
        self.btnSelect.isHidden = true
        if myMoneyFrameworkSettings.shared.showOfflineWallet == true{
            debitCardView.isHidden = true
            cardCollection.isHidden = false
            pageController.isHidden = false
            showDebitOptions = true
        }else{
            setUpDebitCard()
        }
    }
    
    func setUpDebitCard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("creditCardAvailable"), object: nil)
        
        debitCardlblBalance.textColor = .black
        debitCardlblCardNumber.textColor = .black
        debitCardlblCardNumber.isHidden = true
        debitCardbtnConfig.setImage(UIImage(named: "ic_more_icon", in: Bundle(for: BASAHomeHeaderViewComponent.self), compatibleWith: nil), for: .normal)
        debitCardbtnConfig.tag = 0
        if data != nil{
            debitCardlblBalance.text = data!.resultado.cliente?.cuentas?.first?.saldoDisponible?.alnovaDecrypt().moneyFormat()
        }
    }
    
    func SetGradient(colors: [Any]){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: TopHeaderView.bounds.width, height: TopHeaderView.bounds.height))
        gradient.frame = view.bounds
        gradient.colors = colors
        TopHeaderView.layer.insertSublayer(gradient, at: 0)
    }
    
    func handleCardChange(index: Int){
        switch index {
        case 0:
            UIView.animate(withDuration: 0.35, animations: {
                self.lblTitle.textColor = .white
                self.backButton.tintColor = .white
            })
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object: cardType.credit, userInfo: nil))
        case 1:
            //PONER IMAGEN AZUL
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object:  cardType.lending, userInfo: nil))
        default:
            gradient.colors = [UIColor.GSVCPrincipal100.cgColor, UIColor.GSVCPrincipal100.cgColor]
        }
    }
    
    @objc func reloadCards(notification: Notification){
        if notification.object != nil{
            data = notification.object as? BalanceResponse
            
            let amountString = data?.resultado.cliente?.cuentas?.first?.saldoDisponible?.alnovaDecrypt().moneyFormat() ?? "0"
            UserDefaults.standard.setValue(amountString, forKey: "debitAccountBalance")
            debitCardlblBalance.text = amountString
            debitCardlblCardNumber.text = data?.resultado.cliente?.cuentas?.first?.numeroTarjeta?.alnovaDecrypt().tnuoccaFormat
            self.cardCollection.reloadData()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object:  cardType.debit, userInfo: nil))
            pageController.currentPage = 0
            lblTitle.text = "Dinero"
        }
    }
    
    @objc func reloadCreditCard(notification: Notification){
        if notification.object != nil{
            let data = notification.object as! CreditCardResponse
            creditCardData = data
            guard let cell = cardCollection.cellForItem(at: [0,0]) as? BASACardCell else{
                return
            }
            cell.lblCardNumber.text = data.resultado?.tarjetas?.first?.numero?.tnuoccaFormat
            cell.lblExpDate.text = data.resultado?.tarjetas?.first?.expiracion?.replacingOccurrences(of: "-", with: "/")
        }
    }
    
    @objc func reloadCreditCardBalance(notification: Notification){
        if notification.object != nil{
            let data = notification.object as! CreditCardBalanceResponse
            creditCardBalance = data
            guard let cell = cardCollection.cellForItem(at: [0,0]) as? BASACardCell else{
                return
            }
            
            cell.lblBalance.text = data.resultado?.saldoDisponible?.moneyFormatWithoutSplit()
            cell.lblOweMoney.text = "Debes \(data.resultado?.saldoDispuesto?.moneyFormatWithoutSplit() ?? "")"
        }
    }
    
    @objc func reloadLends(notification: Notification){
        if notification.object != nil{
            let data = notification.object as! LendsResponse
            lendsData = data
            cardCollection.reloadData()
            self.pageController.currentPage = 1
        }
    }
    
    @objc func setTableOnlyForLends(notification: Notification){
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        self.btnSelect.isHidden = false
                        self.layoutIfNeeded()
                       })
        showOnlyLendsInCredit = true
    }
    
    @IBAction func debitCardClick(_ sender: Any){
        showDebitOptions = true
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object:  cardType.debit, userInfo: nil))
        if myMoneyFrameworkSettings.shared.showOfflineWallet == true{
            pageController.isHidden = false
            debitCardView.isHidden = true
            cardCollection.isHidden = false
            pageController.currentPage = 0
            self.cardCollection.isScrollEnabled = true
            self.cardCollection.reloadData()
            self.cardCollection.scrollToItem(at: [0,0], at: .left, animated: false)
        }else{
            cardCollection.isHidden = true
            debitCardView.isHidden = false
        }
        debitButton.style = 7
        creditButton.style = 8
        debitButton.isEnabled = false
        creditButton.isEnabled = true
    }
    
    @IBAction func creditCardClick(_ sender: Any){
        showDebitOptions = false
        self.cardCollection.reloadData()
        debitButton.isEnabled = true
        creditButton.isEnabled = false
        debitCardView.isHidden = true
        cardCollection.isHidden = false
        pageController.isHidden = false
        debitButton.style = 8
        creditButton.style = 7
        UIView.animate(withDuration: 0.35, animations: {
            self.lblTitle.textColor = .white
            self.backButton.tintColor = .white
        })
        if showOnlyLendsInCredit == true{
            self.cardCollection.scrollToItem(at: [0,1], at: .left, animated: false)
            self.cardCollection.isScrollEnabled = false
            self.pageController.isHidden = true
            handleCardChange(index: 1)
        }else{
            self.cardCollection.scrollToItem(at: [0,0], at: .left, animated: false)
            self.cardCollection.isScrollEnabled = false
            self.pageController.isHidden = true
            handleCardChange(index: pageController.currentPage)
        }
    }
    
    @IBAction func openDebitConfig(){
        self.tagDebitCardConfigClick()
        let view = BASACardConfigRouter.createModule(credit: false)
        cellViewController.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func close(_ sender: Any){
        if cellViewController != nil{
            cellViewController.dismiss(animated: true, completion: {
                self.cellViewController.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func openConfig(sender: UIButton){
        if cellViewController != nil{
            if sender.tag == 0 {
                createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "configuracion_tarjeta", origin: "debito")
                let view = BASACardConfigRouter.createModule(credit: false)
                cellViewController.navigationController?.pushViewController(view, animated: true)
            }else{
                let view = BASACardConfigRouter.createModule(credit: true)
                cellViewController.navigationController?.pushViewController(view, animated: true)
            }
        }
    }
    
    @objc func methodOfReceivedNotification(notification: NSNotification){
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        self.btnSelect.isHidden = false
                        self.layoutIfNeeded()
                       })
    }
}

extension BASAHomeHeaderViewComponent: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if showDebitOptions ==  true{
            switch indexPath.row{
            case 0:
                let cell = cardCollection.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! BASACardCell
                cell.lblBalance.textColor = .white
                cell.lblOweMoney.isHidden = true
                cell.lblCardNumber.isHidden = true
                cell.lblVigencia.isHidden = true
                cell.lblExpDate.isHidden = true
                cell.btnConfig.isHidden = false
                cell.btnConfig.backgroundColor = UIColor(red: 101/255, green: 156/255, blue: 71/255, alpha: 1.0)
                cell.btnConfig.tag = 1
                cell.lblOweMoney.textColor = .white
                cell.lblCardNumber.textColor = .white
                cell.cardImage.image = UIImage(named: "debitCard3", in: Bundle.init(for: BASAHomeHeaderViewComponent.self), compatibleWith: nil)
                
                cell.lblBalance.text = data?.resultado.cliente?.cuentas?.first?.saldoDisponible?.alnovaDecrypt().moneyFormat()
                
                if creditCardData != nil{
                    cell.lblCardNumber.text = creditCardData?.resultado?.tarjetas?.first?.numero?.tnuoccaFormat
                    cell.lblExpDate.text = creditCardData?.resultado?.tarjetas?.first?.expiracion?.replacingOccurrences(of: "-", with: "/")
                }
                
                cell.btnConfig.tag = 0 
                cell.btnConfig.addTarget(self, action: #selector(openConfig(sender:)), for: .touchUpInside)
                
                cell.CardBackgroundView.layer.borderWidth = 0.5
                cell.CardBackgroundView.layer.cornerRadius = 10
                cell.CardBackgroundView.layer.masksToBounds = true
                return cell
            case 1:
                let cell = cardCollection.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! BASACardCell
                cell.lblBalance.textColor = .white
                cell.lblOweMoney.isHidden = true
                cell.lblCardNumber.isHidden = true
                cell.lblVigencia.isHidden = true
                cell.lblExpDate.isHidden = true
                cell.btnConfig.isHidden = false
                cell.btnConfig.backgroundColor = UIColor(red: 101/255, green: 156/255, blue: 71/255, alpha: 1.0)
                cell.btnConfig.tag = 1
                cell.lblOweMoney.textColor = .white
                cell.lblCardNumber.textColor = .white
                cell.cardImage.image = UIImage(named: "offlineCard", in: Bundle.init(for: BASAHomeHeaderViewComponent.self), compatibleWith: nil)
                cell.bazIcon.isHidden = true
                cell.lblBalance.text = "$0.00"
                
                if creditCardData != nil{
                    cell.lblCardNumber.text = creditCardData?.resultado?.tarjetas?.first?.numero?.tnuoccaFormat
                    cell.lblExpDate.text = creditCardData?.resultado?.tarjetas?.first?.expiracion?.replacingOccurrences(of: "-", with: "/")
                }
                
                cell.btnConfig.isHidden = true
                
                cell.CardBackgroundView.layer.borderWidth = 0.5
                cell.CardBackgroundView.layer.cornerRadius = 10
                cell.CardBackgroundView.layer.masksToBounds = true
                return cell
            default:
                return UICollectionViewCell()
            }
        }else{
            switch indexPath.row{
            case 0:
                let cell = cardCollection.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! BASACardCell
                cell.lblBalance.textColor = .white
                cell.lblExpDate.textColor = .white
                cell.lblVigencia.textColor = .white
                cell.lblOweMoney.isHidden = false
                cell.lblCardNumber.isHidden = false
                cell.lblVigencia.isHidden = false
                cell.lblExpDate.isHidden = false
                cell.btnConfig.isHidden = true
                cell.btnConfig.backgroundColor = .black
                cell.btnConfig.tag = 1
                cell.lblOweMoney.textColor = .white
                cell.lblCardNumber.textColor = .white
                cell.CardBackgroundView.layer.borderColor = UIColor.white.cgColor
                cell.CardBackgroundView.blurBackground(style: .dark, fallbackColor: .white)
                
                if creditCardData != nil{
                    cell.lblCardNumber.text = creditCardData?.resultado?.tarjetas?.first?.numero?.tnuoccaFormat
                    cell.lblExpDate.text = creditCardData?.resultado?.tarjetas?.first?.expiracion?.replacingOccurrences(of: "-", with: "/")
                }
                
                cell.btnConfig.addTarget(self, action: #selector(openConfig(sender:)), for: .touchUpInside)
                
                cell.CardBackgroundView.layer.borderWidth = 0.5
                cell.CardBackgroundView.layer.cornerRadius = 10
                cell.CardBackgroundView.layer.masksToBounds = true
                return cell
            case 1:
                let cell = cardCollection.dequeueReusableCell(withReuseIdentifier: "BASALendViewCVC", for: indexPath) as! BASALendViewCVC
                if lendsData != nil{
                    cell.lblAmount.text = lendsData?.resultado?.pagoLiquidar?.moneyFormatWithoutSplit()
                }
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.cardCollection.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "carrusel", origin: "credito")
        if showDebitOptions == true{
            switch indexPath.row{
            case 1:
                pageController.currentPage = 0
                lblTitle.text = "Dinero"
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object:  cardType.debit, userInfo: nil))
            case 0:
                pageController.currentPage = 1
                lblTitle.text = "Monedero para envío sin conexión"
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object:  cardType.offlineWallet, userInfo: nil))
            default:
                handleCardChange(index: indexPath.row)
            }
        }else{
            if showOnlyLendsInCredit == false{
                switch indexPath.row{
                case 1:
                    lblTitle.text = "Dinero"
                    pageController.currentPage = 0
                    handleCardChange(index: 0)
                case 0:
                    lblTitle.text = "Dinero"
                    pageController.currentPage = 1
                    handleCardChange(index: 1)
                default:
                    handleCardChange(index: indexPath.row)
                }
            }
        }
    }
}

enum cardType{
    case debit
    case credit
    case lending
    case offlineWallet
}

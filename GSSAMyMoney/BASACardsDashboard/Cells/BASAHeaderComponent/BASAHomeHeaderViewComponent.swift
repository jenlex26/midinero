//
//  BASAHomeHeaderViewComponent.swift
//  GSSAFront
//
//  Created by Desarrollo on 15/06/21.
//

import UIKit
import GSSAVisualComponents

class BASAHomeHeaderViewComponent: UITableViewCell {
    
    @IBOutlet weak var cardCollection           : UICollectionView!
    @IBOutlet weak var pageController           : UIPageControl!
    @IBOutlet weak var TopHeaderView            : UIView!
    @IBOutlet weak var backButton               : UIButton!
    @IBOutlet weak var lblTitle                 : UILabel!
    @IBOutlet weak var debitCardContainer       : UIView!
    //MARK: - DebitCard Outlets -
    @IBOutlet weak var debitCardlblBalance      : GSVCLabel!
    @IBOutlet weak var debitCardlblCardNumber   : GSVCLabel!
    @IBOutlet weak var debitCardbtnConfig       : UIButton!
    @IBOutlet weak var debitCardView            : UIView!
    @IBOutlet weak var imgHeader                : UIImageView!
    @IBOutlet weak var debitButton              : GSVCButton!
    @IBOutlet weak var creditButton             : GSVCButton!

    var gradient = CAGradientLayer()
    var cellViewController: UIViewController!
    var data: BalanceResponse?
    
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
        
        // PONER IMAGEN DE DÉBITO
        if let image:UIImage = UIImage(named: "ic_card_backgroud")  {
            self.imgHeader.image = image
        }
        
        
        debitCardView.layer.cornerRadius = 10
        debitCardView.layer.masksToBounds = true

        debitCardView.layer.borderWidth = 0.2
        debitCardView.layer.borderColor = UIColor.lightGray.cgColor
       
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards(notification:)), name: NSNotification.Name(rawValue: "reloadHeaderData"), object: nil)
    }
    
    func setUpDebitCard(){
        debitCardlblBalance.textColor = .black
        debitCardlblCardNumber.textColor = .black
        debitCardlblCardNumber.isHidden = true
        debitCardbtnConfig.setImage(UIImage(named: "ic_more_icon", in: Bundle(for: BASAHomeHeaderViewComponent.self), compatibleWith: nil), for: .normal)
        
        debitCardbtnConfig.tag = 0
       
        if data != nil{
            debitCardlblBalance.text = data!.resultado.cliente?.cuentas?.first?.saldoDisponible
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
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object: headerColorType.credit, userInfo: nil))
        case 1:
            //PONER IMAGEN AZUL
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object:  headerColorType.lending, userInfo: nil))
        default:
            gradient.colors = [UIColor.GSVCPrincipal100.cgColor, UIColor.GSVCPrincipal100.cgColor]
        }
    }
    
    @objc func reloadCards(notification: Notification){
        if notification.object != nil{
           let data = notification.object as! BalanceResponse
            let amountString = data.resultado.cliente?.cuentas?.first?.saldoDisponible ?? "0"
            
            let amountFormat = NSMutableAttributedString.setFormattedText(withStringAmmount: amountString,
                                                                          withNumberOfDecimals: 0,
                                                                          withFontSize: 36,
                                                                          withFontWeight: .bold,
                                                                          withFontColor: .GSVCText100,
                                                                          withLittleCoin: false)
            
            debitCardlblBalance.attributedText = amountFormat
        }
    }
    
    @IBAction func debitCardClick(_ sender: Any){
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "HomeHeaderViewChange"), object:  headerColorType.debit, userInfo: nil))
        debitCardView.isHidden = false
        cardCollection.isHidden = true
        pageController.isHidden = true
        debitButton.backgroundColor = UIColor(red: 130/255, green: 0/255, blue: 255/255, alpha: 1.0)
        debitButton.setTitleColor(.white, for: .normal)
        creditButton.backgroundColor = .white
        creditButton.setTitleColor(.black, for: .normal)
        debitButton.isEnabled = false
        creditButton.isEnabled = true
    }
    
    @IBAction func creditCardClick(_ sender: Any){
        debitButton.isEnabled = true
        creditButton.isEnabled = false
        debitCardView.isHidden = true
        cardCollection.isHidden = false
        pageController.isHidden = false
        debitButton.backgroundColor = .white
        debitButton.setTitleColor(.black, for: .normal)
        creditButton.backgroundColor = UIColor(red: 130/255, green: 0/255, blue: 255/255, alpha: 1.0)
        creditButton.setTitleColor(.white, for: .normal)
        UIView.animate(withDuration: 0.35, animations: {
            self.lblTitle.textColor = .white
            self.backButton.tintColor = .white
        })
        handleCardChange(index: pageController.currentPage)
    }
    
    @IBAction func openDebitConfig(){
        let view = BASACardConfigRouter.createModule(credit: false)
        cellViewController.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func close(_ sender: Any){
        if cellViewController != nil{
            cellViewController.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func openConfig(sender: UIButton){
        if cellViewController != nil{
            if sender.tag == 0 {
                let view = BASACardConfigRouter.createModule(credit: false)
                cellViewController.navigationController?.pushViewController(view, animated: true)
            }else{
                let view = BASACardConfigRouter.createModule(credit: true)
                cellViewController.navigationController?.pushViewController(view, animated: true)
            }
        }
    }
}

extension BASAHomeHeaderViewComponent: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row{
        case 0:
            print("case 0")
            let cell = cardCollection.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! BASACardCell
            cell.lblBalance.textColor = .white
            cell.lblExpDate.textColor = .white
            cell.lblVigencia.textColor = .white
            cell.lblOweMoney.isHidden = false
            cell.lblCardNumber.isHidden = false
            cell.lblVigencia.isHidden = false
            cell.lblExpDate.isHidden = false
            
            cell.btnConfig.backgroundColor = .black
            cell.btnConfig.tag = 1
            cell.lblOweMoney.textColor = .white
            cell.lblCardNumber.textColor = .white
            cell.CardBackgroundView.layer.borderColor = UIColor.white.cgColor
            cell.CardBackgroundView.blurBackground(style: .dark, fallbackColor: .white)
            
            if data != nil{
                cell.lblCardNumber.text! = (data?.resultado.cliente?.cuentas?.first?.numero!.tnuoccaFormat) ?? ""
               // cell.lblBalance.text = data!.resultado.saldoDisponible
            }
            
            cell.btnConfig.addTarget(self, action: #selector(openConfig(sender:)), for: .touchUpInside)
            
            cell.CardBackgroundView.layer.borderWidth = 0.5
            cell.CardBackgroundView.layer.cornerRadius = 10
            cell.CardBackgroundView.layer.masksToBounds = true
            return cell
        case 1:
            print("case 1")
            let cell = cardCollection.dequeueReusableCell(withReuseIdentifier: "BASALendViewCVC", for: indexPath)
            return cell
        default:
           return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.cardCollection.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.row{
        case 1:
            pageController.currentPage = 0
            handleCardChange(index: 0)
        case 0:
            pageController.currentPage = 1
            handleCardChange(index: 1)
        default:
            handleCardChange(index: indexPath.row)
        }
    }
}


extension UIView{
func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

enum headerColorType{
    case debit
    case credit
    case lending
}

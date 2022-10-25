//
//  PaymentOptionsVC.swift
//  Paysikka
//
//  Created by George Praneeth on 23/08/22.
//

import UIKit

class PaymentOptionsVC: UIViewController {

    
    @IBOutlet weak var roundView: UIView!
    
    var enteredAmount:String = ""
    var scannedData:String = ""
    var appMovedtoanother:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundView.roundCorners([.topLeft,.topRight], radius: 20)
        
        print("qwerty ",gpayBtn.tag)
        
//        if gpayBtn.tag == 0 {
//
//            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(PaymentOptionsVC.actionBtngpay))
//            gpayBtn.isUserInteractionEnabled = true
//            gpayBtn.addGestureRecognizer(tapgesture)
//        }
        
//        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(PaymentOptionsVC.actionBtngpay))
//        gpayBtn.isUserInteractionEnabled = true
//        gpayBtn.addGestureRecognizer(tapgesture)
        
        let phonepegesture = UITapGestureRecognizer(target: self, action: #selector(PaymentOptionsVC.actionBtnphonepe))
        phonepe.isUserInteractionEnabled = true
        phonepe.addGestureRecognizer(phonepegesture)
        
        let paytm = UITapGestureRecognizer(target: self, action: #selector(PaymentOptionsVC.actionBtnpaytm))
        paytmimg.isUserInteractionEnabled = true
        paytmimg.addGestureRecognizer(paytm)
        
       
        
        
        print("Payment VC Loaded")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
       print("appmoved status: ",appMovedtoanother)
        
    }
    
    @objc fileprivate func applicationDidBecomeActive() {
        
        if appMovedtoanother == true {
            
            let success :STGPaymentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "STGPaymentsVC") as! STGPaymentsVC
            self.present(success, animated: true)
          //  self.navigationController?.present(success, animated: true)
            
        }
        
        }
    
    @IBOutlet weak var gpayBtn: UIImageView!
    
    @IBOutlet weak var paytmimg: UIImageView!
    
    @IBOutlet weak var phonepe: UIImageView!
    
    @IBAction func imgBtn(_ sender: Any) {
        
        initiatePayment(provider: "gpay", amount: enteredAmount)
        //appMovedtoanother = true
        print("gpay Tapped")
        print("1st response ")
        
    }
    
//    @objc func actionBtngpay() {
//
//        initiatePayment(provider: "gpay", amount: enteredAmount)
//
//        print("gpay Tapped")
//        print("1st response ")
//
//    }
    
    @objc func actionBtnphonepe() {
        
        initiatePayment(provider: "phonepe", amount: enteredAmount)
            //appMovedtoanother = true
        print("Phonepe Tapped")
        print("2nd response ")
        
    }
    
    @objc func actionBtnpaytm() {
        
        initiatePayment(provider: "paytm", amount: enteredAmount)
        //appMovedtoanother = true
        print("paytm Tapped")
        print("3rd response")
        
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    
    func random9DigitString() -> String {
        let min: UInt32 = 100_000_000
        let max: UInt32 = 100_000_000
        let i = min + arc4random_uniform(max - min + 1)
        return String(i)
    }
    
    func initiatePayment(provider:String,amount:String) {
        
        print("provider ",provider,"amount ",amount)
        let number = arc4random()
        print("The computer selected: \(number)")
        let transactionReference = random9DigitString()
        print("The computer selected: \(transactionReference)")
        let result = scannedData
        let modified_Result = result.replacingOccurrences(of: "upi://", with: "\(provider)://upi/")
        let open = modified_Result+"&am=\(amount)"
      //  +"&tr=\(transactionReference)"
        print("open url ",open)
        
        do{
            let modified_url = try open.asURL()
            appMovedtoanother = true
            UIApplication.shared.open(modified_url)
            print("modified_url ",modified_url)
            
        }catch{
            
            print("catched the error from conversion of string to url")
        }
        
        switch UIApplication.shared.applicationState {
        case .active:
           
            //app is currently active, can update badges count here
            break
        case .inactive:
             
           // payment()
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            break
        case .background:
            
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            break
        default:
            break
        }
        
        
//        if UIApplication.shared.canOpenURL(modified_url!) {
//
////          let directionsRequest  = open+"&x-success=sourceapp://?resume=true&x-source=Paysikka"
////
////        guard let direct = URL(string: directionsRequest) else {return}
//
//            UIApplication.shared.open(modified_url!)
//
//        } else {
//          print("Can't open upi on this device.")
//        }
        
        
        if #available(iOS 13.0, *) {
            let sessions = UIApplication.shared.openSessions
            print("iscomSessions ",sessions)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func payment() {
        
        let alertcontrol = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let SuccessAction = UIAlertAction(title: "Success", style: .default){ [self] response in
            
            if response.title == "Success" {
                
               let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                success.paymentStatusText = "Transaction Successful"
                success.paymentStatusImage = "successjson"
                success.paymentText = "Your Transaction has been Successful you will recieve your in 7 Working days"
                
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(success, animated: true)
                
                //  let payment = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "")
                
                //CallBuy_Gold()
                
            }
            
        }
        
        let FailAction = UIAlertAction(title: "Fail", style: .destructive) { [self] response in
            
            let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            success.paymentStatusText = "Payment Failed"
            success.paymentStatusImage = "errorjson"
            success.paymentText = "Your Transaction has been faild if any money has been deducted will be returned 3 to 4 banking days"
            
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(success, animated: true)
            
            print("noaction: ",response)
        }
        
        let pendingAction = UIAlertAction(title: "Transaction In Progress", style: .default){ [self] response in
            
            if response.title == "Transaction In Progress" {
                
                let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                success.paymentStatusText = "Transaction In Progress"
                success.paymentStatusImage = "pendingjson"
                success.paymentText = "Your Transaction is in processing, Please Check again Later"
                
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(success, animated: true)
                
            }
            
        }
        
        
        alertcontrol.addAction(SuccessAction)
        alertcontrol.addAction(FailAction)
        alertcontrol.addAction(pendingAction)
        
        self.present(alertcontrol, animated: true)
        
    }

}

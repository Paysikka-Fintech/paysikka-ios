//
//  STGPaymentsVC.swift
//  Paysikka
//
//  Created by George Praneeth on 05/09/22.
//

import UIKit

class STGPaymentsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func success(_ sender: Any) {
        
        let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
        success.paymentStatusText = "Transaction Successful"
        success.paymentStatusImage = "successjson"
        success.paymentText = "Your Transaction has been Successful you will recieve your in 7 Working days"
        
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.pushViewController(success, animated: true)
        
        self.present(success, animated: true)
        
    }
    
    @IBAction func failure(_ sender: Any) {
        
        let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
        success.paymentStatusText = "Payment Failed"
        success.paymentStatusImage = "errorjson"
        success.paymentText = "Your Transaction has been failed if any money has been deducted will be returned 3 to 4 banking days"
        
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.pushViewController(success, animated: true)
        
        self.present(success, animated: true)
        
    }
    
    @IBAction func transactionProgress(_ sender: Any) {
        
        let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
        success.paymentStatusText = "Transaction In Progress"
        success.paymentStatusImage = "pendingjson"
        success.paymentText = "Your Transaction is in processing, Please Check again Later"
        
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.pushViewController(success, animated: true)
        
        self.present(success, animated: true)
        
    }
    
    @IBAction func decline(_ sender: Any) {
        
        let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
        success.paymentStatusText = "Transaction Decline"
        success.paymentStatusImage = "errorjson"
        success.paymentText = "Your Transaction has been Declined"
        
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.pushViewController(success, animated: true)
        
        self.present(success, animated: true)
        
    }
    
}

//
//  AddChargesVC.swift
//  Paysikka
//
//  Created by George Praneeth on 24/08/22.
//

import UIKit
import SwiftUI

class AddChargesVC: UIViewController {
    
    @IBOutlet weak var UPIID:UILabel!
    
    @IBOutlet weak var enteredamountLbl: UILabel!
    
    @IBOutlet weak var surcharge: UILabel!
    
    @IBOutlet weak var grandTotal: UILabel!
    
    var upiid:String = ""
    var enteredAmount :String = ""
    var scannedData:String = ""
    var grandtotal:String = ""
    
    var with:String = ""
    var rechargeTtpe:String = ""
    var amount:String = ""
    var operatorName:String = ""
    var phonenum:String = ""
    var circle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton(title: "")
        
    }
    
//    let headers = [
//        HTTPHeader(field: "content-type", value: "application/json"),
//    ]
//
//    let postParameters = [
//        "title": "foo",
//        "body": "bar",
//        "userId": 1
//    ] as [String : AnyObject]

  //  let postRequest = APIRequest(method: .get, path: "auth/extraprice",body: postParameters)
    
    
   /* func call_Charges(){
        
        do{
            
        let request = try APIRequest(method: .get, path: "auth/extraprice",body: ["amount":enteredAmount])
        APIClient().perform(request) { (result) in
            
            switch result {
                
            case .success(let response):
                print(response.body)
                 
            case .failure(let error):
                print(error.localizedDescription)
                
            }
          
            
            }
        }catch{
            
        }
    
        
    }*/
    
    func Call_CyrusApi(with:String,rechargeType:String,amount:String,operatorCode:String,phonenum:String,circle:String) {
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/recharge/\(with)"
        guard let operators = Foundation.URL(string:fullurl) else {return}
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        let dict = ["amount":amount,"operator":operatorCode,"number":phonenum,"circle":circle,"txnid":timestamp]
        
        print("Body Params: ",dict)
        
        let jsondata = try? JSONSerialization.data(withJSONObject: dict, options:.fragmentsAllowed)
        var url = URLRequest(url: operators)
        url.httpMethod = "POST"
        url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        DispatchQueue.main.async {
                            
                        if let msg = recieved["message"] as? String {
                        Alert.showAlertError(on: self, message: msg)
                        }
                        
                        }
                        
                        print("response from Cyrus ",recieved)
                        
                    }catch{
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        
                        print(recieved["message"])
                        
                        DispatchQueue.main.async {
                            
                            let alert = UIAlertController(title: "PaySikka", message: msg, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default)
                            
                            alert.addAction(action)
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        print("failure ",recieved)
                        
                    }
                    catch {
                        print("there's a catch from operators")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    
    func Call_ExtraPrice(selected:String) {
        
        LoadingOverlay.shared.showOverlay()
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"auth/extraprice"
        guard let operators = Foundation.URL(string:fullurl) else {return}
        var url = URLRequest(url: operators)
        url.httpMethod = "POST"
        let stringtoint = Int(selected)
        let dict = ["amount":stringtoint]
        print("params ",dict)
        
        let jsondata = try? JSONSerialization.data(withJSONObject: dict, options:.fragmentsAllowed)
        url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("recievedData: ",recieved)
                        
                        let original = recieved["original"] as! Int
                        
                        let extra = recieved["extra"] as! Double
                        
                        let total = recieved["total"] as! Double
                        
                        DispatchQueue.main.async { [self] in
                            surcharge.text = "₹ \(String(describing: extra))"
                            grandTotal.text  = "₹ "+String(String(format:"%.02f", total))
                            grandtotal = String(String(format:"%.02f", total))
                            enteredamountLbl.text = "₹ "+String(original)
                        }
                        
                        print("success from  ",recieved)
                        
                        
                    }catch{
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    LoadingOverlay.shared.hideOverlayView()
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        
                        print(recieved["message"])
                        
                        DispatchQueue.main.async {
                            
                            let alert = UIAlertController(title: "PaySikka", message: msg, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default)
                            
                            alert.addAction(action)
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        print("failure ",recieved)
                        
                    }
                    catch {
                        print("there's a catch from operators")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    @IBAction func paytapped(_ sender: Any) {
    
    Call_CyrusApi(with: with, rechargeType: rechargeTtpe, amount: amount, operatorCode: operatorName, phonenum: phonenum, circle: circle)
        
//        let pay:PaymentOptionsVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "paymentOptions") as! PaymentOptionsVC
//        pay.scannedData = "upi://pay?pa=ipay.94.198784.9177123162@icici&pn=PAYSIKKA&am=\(grandtotal)"
//        pay.enteredAmount = grandtotal
//        pay.view.isOpaque = false
//        pay.view.backgroundColor = .clear
//        pay.modalPresentationStyle = .overCurrentContext
//        self.navigationController?.present(pay, animated: true)
        
    }
    
    
    
}

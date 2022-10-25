//
//  RedeemViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 11/07/22.
//

import UIKit
import SwiftMessages

class RedeemViewController: UIViewController {
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    @IBOutlet weak var walletgrams: UILabel!
    
    @IBOutlet weak var goldWalletView: UIView!
    
    @IBOutlet weak var enteredgramsField: UITextField!
    
    @IBOutlet weak var proceed_Btn: UIButton!
    
    @IBOutlet weak var livepriceView: UIView!
    
    @IBOutlet weak var pergramprice: UILabel!
    
    var redeemModel:[RedeemModel] = []
    
    var globalGoldBalance:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredgramsField.keyboardType = .numberPad
      
        goldWalletView.addShadow(offset: CGSize.zero, color:.lightGray, radius: 5, opacity:2)
        
        goldWalletView.roundCorners(.allCorners, radius: 10)
        livepriceView.roundCorners(.allCorners, radius: 10)
        
        livepriceView.addShadow(offset: CGSize.zero, color: .lightGray, radius: 5, opacity: 2)
        
        proceed_Btn.addTarget(self, action: #selector(callReddem), for: .touchUpInside)
        
        getGramsBalance()
        
        backButton(title: "Redeem")
        
      //  setupToolbar()
    }
    
    func setupToolbar() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Create a toolbar
        let bar = UIToolbar()
        
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        
        //Add the toolbar to our textfield
        enteredgramsField.inputAccessoryView = bar
        
    }
    
    @objc func dismissMyKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
            view.frame.origin.y = -170 // Move view 170 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
            view.frame.origin.y = 0 // Move view to original position
    }
    
    
    @objc func callReddem(){
        
        let enteredgrams = enteredgramsField.text ?? ""
        
        if enteredgramsField.text == "" || enteredgrams < "2" {
            
            let msg  = "Please Enter Minimum 2 Grams"
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: msg)
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
        }else if enteredgrams > "30" {
            
            let msg  = "Max 30 Grams"
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: msg)
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
        } else {
            
            print("gramsEntered ",enteredgrams)
            
            let alertcontrol = UIAlertController(title: "Transaction", message: "Do You Want To Make it", preferredStyle: .actionSheet)
            
            let action = UIAlertAction(title: "Success", style: .default){ [self] response in
                
                if response.title == "Success" {
                    
                call_Redeem(gramsentered: enteredgrams)
                    
                }
                
            }
            
            let noaction = UIAlertAction(title: "Fail", style: .destructive) { [self] response in
                
                let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                success.paymentStatusText = "Payment Failed"
                success.paymentStatusImage = "errorjson"
                success.paymentText = "Your Transaction has been faild if any money has been deducted will be returned 3to4 banking days"
                
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
            
            alertcontrol.addAction(action)
            alertcontrol.addAction(noaction)
            alertcontrol.addAction(pendingAction)

            self.present(alertcontrol, animated: true)
           
        }
        
    }
    
    
    func call_Redeem(gramsentered:String) {
        
        LoadingOverlay.shared.showOverlay()
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/redeem"
        guard let redeem = URL(string: fullurl) else {return}
        
        let auth = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        let dict = ["grams":gramsentered]
        
        print("params ",dict)
        
        let jsondata = try? JSONSerialization.data(withJSONObject: dict, options:.fragmentsAllowed)
        
         print("jsondata ",jsondata)
        
         print("auth ",auth)
        
        var url = URLRequest(url: redeem)
        url.httpMethod = "POST"
         url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.allHTTPHeaderFields = ["Authorization":auth]
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                   print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                        let dataformat = recieved["dataformat"] as! NSDictionary
                        let description = dataformat["description"] as! String
                        let transactionID = dataformat["transactionId"] as! Int
                        
                        LoadingOverlay.shared.hideOverlayView()
                        
//                        for x in recieved {
//
//                            let Redeemtransaction = RedeemModel(fromDictionary: x as? [String:Any] ?? ["":""])
//                            redeemModel.append(Redeemtransaction)
//
//                        }
                        
                        
                        print("success ",recieved)
                      //  print("transaction ",redeemModel[0].dataformat?.descriptionField,redeemModel[0].dataformat?.transactionId)
                        
                        
                        DispatchQueue.main.async {
                            
                            let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                            success.paymentStatusText = "Your transaction Is Successful"
                            success.paymentStatusImage = "successjson"
                            success.paymentText = "TransactionID:  \(transactionID)"+"\n"+description
                            self.navigationController?.isNavigationBarHidden = true
                            self.navigationController?.pushViewController(success, animated: true)
                            
                        }
                        
//                        SwiftMessages.show {
//
//                            let view = MessageView.viewFromNib(layout: .cardView)
//
//                            view.configureTheme(.success)
//
//                            view.configureContent(body: msg)
//
//                            view.button?.isHidden = true
//                            view.titleLabel?.isHidden = true
//
//                            return view
//
//                        }
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        
                        print(recieved["message"])
                        
                        LoadingOverlay.shared.hideOverlayView()
                        DispatchQueue.main.async {
                            
                            let alert = UIAlertController(title: "PaySikka", message: msg, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default)
                            
                            alert.addAction(action)
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        print("failure ",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    func getGramsBalance() {
        
        LoadingOverlay.shared.showOverlay()
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/wallet"
        guard let wallet = URL(string: fullurl) else {return}
        
        var url = URLRequest(url: wallet)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let auth = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        url.allHTTPHeaderFields = ["Authorization":auth]
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("success ",recieved)
                        
                        LoadingOverlay.shared.hideOverlayView()
                        
                        let Balance = recieved["wallet"] as? Double ?? 0.0
                        let goldBalance = String(String(format:"%.02f", Balance))
                    
                        globalGoldBalance = goldBalance
                        
                        DispatchQueue.main.async { [self] in
                        
                        walletgrams.text = "Available Grams :     \(globalGoldBalance) gms"
                            
                        }
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        
                        print(recieved["message"])
                        
                        LoadingOverlay.shared.hideOverlayView()
                        
                        DispatchQueue.main.async {
                            
                            let alert = UIAlertController(title: "PaySikka", message: msg, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default)
                            
                            alert.addAction(action)
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        print("failure ",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    func getLivePrice() {
        
        LoadingOverlay.shared.showOverlay()
        let auth = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        guard let loginurl = Foundation.URL(string: "http://dev.paysikka.com/api/user/liveprice") else {return}
        
        var url = URLRequest(url: loginurl)
        url.httpMethod = "GET"
        // url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.allHTTPHeaderFields =  ["Authorization": "Bearer "+auth]
        
        print("live url ",url.allHTTPHeaderFields)
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            let data = dataResponse
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                
                print("Live Price StatusCode ",httpResponse.statusCode)
                
                if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let liveprice = recieved["liveprice"] as! NSDictionary
                        
                        let buyprice = liveprice["buy_price_per_gram"] as? NSNumber ?? 0
                        
                       // print("GST FORm : \(gst)")
                        
                        let buy : String = buyprice.stringValue
                        
                        print("live success ",recieved)
                        
                        DispatchQueue.main.async { [self] in
                            
                            pergramprice.text = "        ₹ \(buy) per gram"
                        }
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("error ",recieved)
                        
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else{
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("error ",recieved)
                        
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }
            }
        }
        dataTask.resume()
    }
    
}

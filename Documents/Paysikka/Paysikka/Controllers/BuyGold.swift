//
//  BuyGold.swift
//  Paysikka
//
//  Created by George Praneeth on 12/07/22.
//

import UIKit
import SwiftMessages
import AudioToolbox

class BuyGold: UIViewController {

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBOutlet weak var goldWalletShadow: UIView!
    
    @IBOutlet weak var totalgrams: UILabel!
    
    @IBOutlet weak var enteramount: UITextField!
    
    @IBOutlet weak var livepriceView: UIView!
    
    @IBOutlet weak var pergramprice: UILabel!
    
    @IBOutlet weak var segmentctrl: UISegmentedControl!
    
    @IBOutlet weak var switchedLbl: UILabel!
    
    @IBOutlet weak var noteLbl: UILabel!
    
   // var calculatdGold:String = ""
    
    var enterText:String = ""
    
    var globalGoldBalance:String = ""
    
    var paymentID:String = "24352362464363"
    
    var sellprice:NSNumber = 0
    
    var gst:String = ""
    
    var from:String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if enteramount.hasText {
           enteramount.text = ""
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton(title: "BuyGold")
        
        getGramsBalance()
        
        getLivePrice()
        
        //setupToolbar()
        
        enteramount.keyboardType = .numberPad
        
        segmentctrl.addTarget(self, action: #selector(onsegmentChange), for: .valueChanged)
        
        //segmentctrl.tintColor = UIColor.black
        
        noteLbl.tintColor = UIColor.black
        
        let note = noteLbl.isHidden
        
        print("note ",note)
        
        enteramount.addTarget(self, action: #selector(ontextvalueChange), for: .editingChanged)
        
       // enteramount.becomeFirstResponder()
        
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
        enteramount.inputAccessoryView = bar
        
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
    
    @objc func ontextvalueChange() {
        
     //   guard let famount = enteramount.text else {return}
        
//        let buyprice1:String! = sellprice.stringValue
//        let buyprice:Double = Double(buyprice1)!
//        let doublea:Double = Double(famount) ?? 0.0
//        let calval: Double = doublea*buyprice
//        let valcal:Double = doublea/buyprice
//
//        let calculatdGold = String(format: "%.2f", calval)
//        let calculatedAmount = String(format: "%.2f", valcal)
        
      //  print("calculatdGold ",calculatdGold,"calculatedAmount ",calculatedAmount)
        
        switch segmentctrl.selectedSegmentIndex {
        case 0:
            
             let famount = enteramount.text  ?? ""
                 enterText = famount
                 from = "gold"
            
//            let buyprice1:String! = sellprice.stringValue
//            let buyprice:Double = Double(buyprice1)!
//            let doublea:Double = Double(famount) ?? 0.0
//            let calval: Double = doublea*buyprice
//
//            print("grams ",calval,"entered",enteramount.text,"sellprice",buyprice)

        case 1:

            let famount = enteramount.text ?? ""
            enterText = famount
            from = "ruppees"
//            let buyprice1:String! = sellprice.stringValue
//            let buyprice:Double = Double(buyprice1)!
//            let doublea:Double = Double(famount) ?? 0.0
//            let calval: Double = doublea*buyprice
//
//            print("ruppees ",calval,"entered",enteramount.text,"sellprice",buyprice)


        default:
            break
        }
        
    }
    
    @objc func onsegmentChange(){
        
        switch segmentctrl.selectedSegmentIndex {
        case 0:
            
            print("segment change ",segmentctrl.selectedSegmentIndex)
            
            enteramount.attributedPlaceholder = NSAttributedString(string:  "Grams", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            
//            segmentctrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
//            segmentctrl.selectedSegmentTintColor = UIColor.init(named: "AppColor")
            
            noteLbl.text = ""
            switchedLbl.text = "Enter Grams"
            
        case 1:
            
            print("segment change ",segmentctrl.selectedSegmentIndex)
            
            enteramount.attributedPlaceholder = NSAttributedString(string: "Amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            
//            segmentctrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//            segmentctrl.selectedSegmentTintColor = UIColor.init(named: "AppColor")
            
            noteLbl.text = "Note: Please Enter a minimum of 100 Rupees"
            switchedLbl.text = "Enter Amount"
            
        default:
            break
        }
       
    }
    

    @IBAction func proceedBtnTapped(_ sender: Any) {
        
        guard let amount = enteramount.text else {return}
        
        let Int_amount = Int(amount) ?? 0
        
        print("proceedBtnTapped from amount ",amount,"Int_amount ",Int_amount)
        print("selectedSegmentIndex ",segmentctrl.selectedSegmentIndex)
        print("from ",from)
        
        if from == "gold" && amount == "" || Int_amount == 0 {
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: "Please Enter A Minimum Value")
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }else if from == "gold" && Int_amount > 30 {
            
            enteramount.text = ""
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: "Max 30 grams")
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }else if from == "ruppees" && Int_amount < 100 {
            
            enteramount.text = ""
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: "Please Enter A Minimum Value of 100")
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
         }else if from == "ruppees" && amount == "" || Int_amount == 0 {
             
             enteramount.text = ""
             
             SwiftMessages.show {
                 
                 let view = MessageView.viewFromNib(layout: .cardView)
                 
                 view.configureTheme(.error)
                 
                 view.configureContent(body: "Please Enter A Minimum Value")
                 
                 view.button?.isHidden = true
                 view.titleLabel?.isHidden = true
                 
                 return view
                 
             }
             
             AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
             
         } else {
            
            let buyGoldInfo:BuyGoldInfoController = UIStoryboard(name: "BuyGold", bundle: nil).instantiateViewController(withIdentifier: "BuyGold_Information") as! BuyGoldInfoController
            
            let liveprice = sellprice.stringValue
            buyGoldInfo.amount = enterText
            buyGoldInfo.LivePrice = liveprice
            buyGoldInfo.gst = gst
            buyGoldInfo.from = from
            
            print("sent to buyGoldInfo live price ",liveprice,"sent to buyGoldInfo amount \(enterText)","sent to buyGoldInfo gst \(gst)","","sent to buyGoldInfo from \(from)")
             
            
            self.navigationController?.pushViewController(buyGoldInfo, animated: true)
            
        }
        
        /*
         //        switch segmentctrl.selectedSegmentIndex {
         //        case 0:
         //
         //            if amount == "" || amount == "0" {
         //
         //                SwiftMessages.show {
         //
         //                    let view = MessageView.viewFromNib(layout: .cardView)
         //
         //                    view.configureTheme(.error)
         //
         //                    view.configureContent(body: "Please Enter Values")
         //
         //                    view.button?.isHidden = true
         //                    view.titleLabel?.isHidden = true
         //
         //                    return view
         //
         //                }
         //
         //            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
         //
         //            }else if amount > "30" {
         //
         //                enteramount.text = ""
         //
         //                SwiftMessages.show {
         //
         //                    let view = MessageView.viewFromNib(layout: .cardView)
         //
         //                    view.configureTheme(.error)
         //
         //                    view.configureContent(body: "Max 30 gms")
         //
         //                    view.button?.isHidden = true
         //                    view.titleLabel?.isHidden = true
         //
         //                    return view
         //
         //                }
         //            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
         //
         //            }else{
         //
         //                let buyGoldInfo:BuyGoldInfoController = UIStoryboard(name: "BuyGold", bundle: nil).instantiateViewController(withIdentifier: "BuyGold_Information") as! BuyGoldInfoController
         //
         //              //  print("calculatdGold ",calculatdGold,"calculatedAmount ",calculatedAmount)
         //
         //                //buyGoldInfo.gold = calculatdGold
         //                buyGoldInfo.amount = enterText
         //                buyGoldInfo.LivePrice = sellprice.stringValue
         //                buyGoldInfo.gst = gst
         //                buyGoldInfo.from = from
         //
         //                self.navigationController?.pushViewController(buyGoldInfo, animated: true)
         //
         //            }
         //
         //        case 1:
         //
         //            if amount == "" {
         //
         //                SwiftMessages.show {
         //
         //                    let view = MessageView.viewFromNib(layout: .cardView)
         //
         //                    view.configureTheme(.error)
         //
         //                    view.configureContent(body: "Please Enter Values")
         //
         //                    view.button?.isHidden = true
         //                    view.titleLabel?.isHidden = true
         //
         //                    return view
         //
         //                }
         //
         //            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
         //
         //            }else if amount < "100" || amount == "0"{
         //
         //                enteramount.text = ""
         //
         //                SwiftMessages.show {
         //
         //                    let view = MessageView.viewFromNib(layout: .cardView)
         //
         //                    view.configureTheme(.error)
         //
         //                    view.configureContent(body: "Please enter a minimum of 100")
         //
         //                    view.button?.isHidden = true
         //                    view.titleLabel?.isHidden = true
         //
         //                    return view
         //
         //                }
         //
         //                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
         //
         //            }else{
         //
         //                let buyGoldInfo:BuyGoldInfoController = UIStoryboard(name: "BuyGold", bundle: nil).instantiateViewController(withIdentifier: "BuyGold_Information") as! BuyGoldInfoController
         //
         //              //  print("calculatdGold ",calculatdGold,"calculatedAmount ",calculatedAmount)
         //
         //                //buyGoldInfo.gold = calculatdGold
         //                buyGoldInfo.amount = enterText
         //                buyGoldInfo.LivePrice = sellprice.stringValue
         //                buyGoldInfo.gst = gst
         //                buyGoldInfo.from = from
         //
         //                self.navigationController?.pushViewController(buyGoldInfo, animated: true)
         //            }
         //
         //        default:
         //            break
         //
         //        }*/
        
        /*
         let alertcontrol = UIAlertController(title: "Demo Transaction", message: "Transaction Status", preferredStyle: .actionSheet)
         
         let action = UIAlertAction(title: "Success", style: .default){ response in
         
         if response.title == "Success" {
         let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
         success.paymentStatusText = "You Transaction is SuccessFul"
         success.paymentStatusImage = "checkmark.seal.fill"
         
         success.modalPresentationStyle = .fullScreen
         self.navigationController?.present(success, animated: true)
         
         print("noaction: ",response)
         
         
         }else{
         
         
         }
         
         }
         
         let noaction = UIAlertAction(title: "Fail", style: .destructive) { response in
         
         let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
         success.paymentStatusText = "Payment Failed"
         success.paymentStatusImage = "errorcross"
         success.modalPresentationStyle = .fullScreen
         self.navigationController?.present(success, animated: true)
         
         print("noaction: ",response)
         }
         
         alertcontrol.addAction(action)
         alertcontrol.addAction(noaction)
         
         self.present(alertcontrol, animated: true)
         
         */
        
    }
    
}

extension BuyGold {

    func getGramsBalance(){
        LoadingOverlay.shared.showOverlay()
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/wallet"
        guard let wallet = URL(string: fullurl) else {return}
        
        var url = URLRequest(url: wallet)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        guard let auth = UserDefaults.standard.string(forKey: "accessToken") else {return}
        url.allHTTPHeaderFields = ["Authorization":auth]
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            if let data = dataResponse {
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    
                    if httpResponse.statusCode == 200 {
                        LoadingOverlay.shared.hideOverlayView()
                        do {
                            
                            let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                            
                            print("success ",recieved)
                            
                            let Balance = recieved["wallet"] as? Double ?? 0.0
                            let goldBalance = String(String(format:"%.02f", Balance))
                            print("gold Bal ",goldBalance)
                            globalGoldBalance = goldBalance
                            
                            DispatchQueue.main.async { [self] in
                                totalgrams.text = "Available Grams :    \(globalGoldBalance) gms"
                            }
                            
                        }
                        catch {
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
                            print("there's a catch")
                        }
                        
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    func getLivePrice() {
        
        LoadingOverlay.shared.showOverlay()
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/liveprice"
        guard let liveprice = URL(string: fullurl) else {return}
        
        let auth = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        var url = URLRequest(url: liveprice)
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
                        
                        gst = liveprice["taxPercentage"] as? String ?? ""
                        
                        let buyprice = liveprice["buy_price_per_gram"] as? NSNumber ?? 0
                        
                        let sellPrice  = liveprice["sell_price_per_gram"] as? NSNumber ?? 0
                        
                        print("sell ",sellPrice)
                        
                        sellprice = sellPrice
                        
                       // print("GST FORm : \(gst)")
                        
                     //   let buy : String = buyprice.stringValue
                        
                        print("live success ",recieved)
                        
                        DispatchQueue.main.async { [self] in
                            
                            pergramprice.text = "         ₹ \(sellprice.stringValue) per gram"
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
                        
                        LoadingOverlay.shared.hideOverlayView()
                        
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

extension BuyGold : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
        return updatedText.count <= 2
    
    }
    
    
    
    
    
}

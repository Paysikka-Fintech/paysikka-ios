//
//  BuyGoldInfoController.swift
//  Paysikka
//
//  Created by George Praneeth on 26/07/22.
//

import UIKit
import Alamofire
import Foundation


class BuyGoldInfoController: UIViewController {
    
    
    @IBOutlet weak var countDownLbl: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    
    @IBOutlet weak var taxesleviesLbl: UILabel!
    
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var roundoffValue: UILabel!
    
    @IBOutlet weak var payableAmount: UILabel!
    
    @IBOutlet weak var goldrateLbl: UILabel!
    
    @IBOutlet weak var payment_Tapped: UIButton!
    
    var gold,amount:String!
    var taxcal,paycal,ro:Double!
    var count = 300
    var accesstoken:String = ""
    var LivePrice:String!
    var mobile,email:String!
    var URL:String! = nil
    var gst:String = "0"
    var isCheckMark:Bool = false
    var subWalletAmount = 0.0
    var paycalValue:Double!
    var isPaymentCancelled:Bool = false
    var page:String = ""
    var sellprice:NSNumber = 0
    var buyprice:NSNumber = 0
    var from:String = ""
    var user_grams:String = ""
    var total_Amount:Double = 0
    
    #warning("change the payment id in while going to production")
    var paymentID:String = "24352362464363"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton(title: "Gold Suvidha")
        
        view.backgroundColor = .white
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        payment_Tapped.roundCorners(.allCorners, radius: 10)
        
        payment_Tapped.addTarget(self, action: #selector(payment), for: .touchUpInside)
        
        setDetails()
        
        getLivePrice()
        
        print("amount from buygold",amount,"gold value from buy gold",gold)
        
    }
    
    @objc func payment() {
        
        let alertcontrol = UIAlertController(title: "Transaction", message: "Do You Want To Make it", preferredStyle: .actionSheet)
        
        let SuccessAction = UIAlertAction(title: "Success", style: .default){ [self] response in
            
            if response.title == "Success" {
            
                let pay:PaymentOptionsVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "paymentOptions") as! PaymentOptionsVC
                let amount = String(1)
                let generateurl = "upi://pay?pa=118895251003333@cnrb&pn=GOLDSIKKA%20LIMITED&mc=5094&tr=1234567887654321&tn=Pay%20to%20Merchant&am=0&mam=0&cu=INR&refUrl=http://npci.org/upi/schema/"
                pay.scannedData = generateurl
                pay.enteredAmount = amount
                
                pay.view.isOpaque = false
                pay.view.backgroundColor = .white
                pay.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(pay, animated: true)
                
              //  let payment = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: <#T##String#>)
            
             //CallBuy_Gold()
                
            }
            
        }
        
        let FailAction = UIAlertAction(title: "Fail", style: .destructive) { [self] response in
            
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
        

        alertcontrol.addAction(SuccessAction)
        alertcontrol.addAction(FailAction)
        alertcontrol.addAction(pendingAction)
        
        self.present(alertcontrol, animated: true)
        
    }
    
    func CallBuy_Gold() {
        
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/buygold"
        guard let buygold = Foundation.URL(string: fullurl) else {return}
        
        let amount = String(total_Amount)
        
        print("Payable_Amount ",amount)
        
        let dict = ["amount":"1","paymentid":paymentID]
        
        print("params ",dict)
        
        let jsondata = try? JSONSerialization.data(withJSONObject: dict, options:.fragmentsAllowed)
        
        print("jsondata ",jsondata)
        
        let auth = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        var url = URLRequest(url: buygold)
        url.httpMethod = "POST"
        url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.allHTTPHeaderFields = ["Authorization":auth]
        
        let dataTask = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("success ",recieved)
                        
                        let dataformat = recieved["dataformat"] as! NSDictionary
                        let description = dataformat["description"] as! String
                        let transactionID = dataformat["transactionId"] as! Int
                        
                        DispatchQueue.main.sync {
                            
                            let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                            
                            success.paymentText = "Your Tansaction Is Successful"
                            success.paymentStatusImage = "successjson"
                            success.paymentText = "TransactionID:  \(transactionID)"+"\n"+description
                            self.navigationController?.isNavigationBarHidden = true
                            self.navigationController?.pushViewController(success, animated: true)
                        }
                       
                        
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
                        print("there's a catch")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    func setDetails() {
        
        print(sellprice.stringValue)
        
        let buyprice1:String! = "4600"
        let buyprice:Double = Double(buyprice1)!
        let doublea:Double = Double(amount) ?? 0.0
        print("doublea ",doublea,buyprice)
        var calval:Double = doublea*buyprice
        var valcal:Double =  doublea/buyprice
        let calculatedAmount = String(format: "%.2f", valcal)
        
//        if from == "gold"{
//
//          amount = String(calval)
//
//        }
        
        print("amount from setDetails ",amount)
       
        
        let calculatdGold = String(format: "%.4f", calval)
        
        print("calculatdGold ",calval,"calculatedAmount ",valcal)
        
        let livePriceText = "Live Price \u{20B9}"
        let pergram = " per gram"
        goldrateLbl.text = livePriceText+LivePrice+pergram
        
        if from == "ruppees"{
            
            let calval:Double = doublea/buyprice
            
            let calculatdGold = String(format: "%.04f", calval)
            amountLbl.text = "\u{20B9} "+amount+".00"
            quantityLbl.text = "\(calculatedAmount)"+" grams"
            total_Amount = Double(amount) ?? 0.0
            print("from ruppess")
            
        }else if from  == "gold"{
            
            let valcal:Double = doublea*buyprice
            let calculatedAmount = String(format: "%.00f", valcal)
            total_Amount = valcal
            amountLbl.text = "\u{20B9} "+calculatedAmount+".00"
            user_grams = amount
            quantityLbl.text = "\(user_grams)"+" grams"
            amount = calculatedAmount
            print("from gold")
            
        }
        
        
        // amount_label.text = "\u{20B9} "+String(format: "%.2f", amount)
        
        // gst_label.text = gst.stringValue
        print("GST : \(gst)")
        
        //  let gst_s:Int = gst
        let a:Double! = Double(0) // firstText is UITextField
        
        print("gst : \(a)")
        
        let gstcalculationbyhundrad = a/Double(100)
        
        let am = Double(amount)!
        
        taxcal =  Double(gstcalculationbyhundrad)*Double(amount+".00")!
        
        ro = taxcal+Double(am)
        
        totalAmount.text = "\u{20B9} "+String(format: "%.2f", ro)
        
        taxesleviesLbl.text = "\u{20B9} "+String(format: "%.2f", taxcal)
        
        paycal = taxcal+Double(amount+".00")!
        
        let rfvalue = paycal.rounded()-ro
        
        // if rfvalue > 0.50{
        if paycal.rounded() >= ro{
            roundoffValue.text = "\u{20B9} +"+String(format: "%.2f", rfvalue)
            roundoffValue.textColor = UIColor.green
            
        }else{
            roundoffValue.text = "\u{20B9} "+String(format: "%.2f", rfvalue)
            roundoffValue.textColor = UIColor.red
            
        }
        
        paycal.round()
        
        payableAmount.text = "\u{20B9} "+String(format: "%.2f", paycal)
        paycalValue = paycal
        
    }
    
    
    @objc func update() {
        if(count > 0) {
            let (m,s) = secondsToHoursMinutesSeconds(seconds: count)
            
            // let minutes:Int = count / 3600 , (count % 3600) / 60, (count % 3600) % 60
            
            let countdown: String = "\(m):\(s)"
            let countdowntext = NSLocalizedString("Count Down :", comment: "")
            
            countDownLbl.text = countdowntext+" "+countdown
            
            
            // TimerLabel.text = "Count Down : \(m) : \(s)"
            
            //  print("\(count) seconds to the end of the world")
            count -= 1
            
        } else if count == 0 {
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update_stop), userInfo: nil, repeats: false)
        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds % 3600 / 60, (seconds % 3600) % 60)
    }
    
    @objc func update_stop() {
        if(count == 0) {
            
            // print("stop seconds to the end of the world")
            //Apihit()
            //            let BuyGoldForm : BuyGoldForm = self.storyboard?.instantiateViewController(withIdentifier: "BuyGoldForm") as! BuyGoldForm
            //self.navigationController?.pushViewController(BuyGoldForm, animated: true)
            count -= 1
            
        }
    }
    
    
    
    //https://staging-api.dev.goldsikka.in/api/gold/current/price
    
    
    func getLivePrice() {
        
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
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let liveprice = recieved["liveprice"] as! NSDictionary
                        
                        gst = liveprice["taxPercentage"] as? String ?? "0"
                        sellprice = liveprice["sell_price_per_gram"] as? NSNumber ?? 0
                        buyprice = liveprice["buy_price_per_gram"] as? NSNumber ?? 0
                        
                        print("GST FORm : \(gst)")
                        
                        let sell : String = sellprice.stringValue
                        let buy : String = buyprice.stringValue
                        
                        LivePrice = sell
                        
                        print("live success ",recieved)
                        
                    }
                    catch {
                        
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
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

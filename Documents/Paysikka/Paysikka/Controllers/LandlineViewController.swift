//
//  LandlineViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 20/09/22.
//

import UIKit

class LandlineViewController: UIViewController {

    @IBOutlet weak var selectoperator: UILabel!
    
    @IBOutlet weak var telephoneNumber: UITextField!
    
    @IBOutlet weak var msglbl: UILabel!
    
    @IBOutlet weak var serviceTitle: UILabel!
    
    @IBOutlet weak var titleDescription: UILabel!
    
    @IBOutlet weak var operatorTilte: UILabel!
    
    @IBOutlet weak var enteredAmount: UITextField!
    
    var operatorsModel:OperatorsModel!
    
    var from:String = ""
    var selectedProvider:String = ""
    var selectedServiceTitle:String = ""
    var placholderText:String = ""
    
    ///Variables to Call Cyrus Api
    var rechargeType:String = ""
    var amonut:String = ""
    var operatorcode:String = ""
    var dynamicNum:String = ""
    var circle:String = ""
    var cellData:String?
    
    
    @IBAction func continueTapped(_ sender: Any) {
        
        guard let num = telephoneNumber.text else { return }
        
        guard let amount = enteredAmount.text else{ return }
        
        if from == Providers.Electricity.rawValue
        {
            if telephoneNumber != nil  && enteredAmount != nil{
                Call_CyrusApi(with: "Electricity", rechargeType: operatorsModel.serviceType, amount: amount, operatorCode: operatorsModel.operatorCode, dynamicnum: num, circle: circle)
            }else{
                Alert.showAlertError(on: self, message: "Fill All Details")
                
            }
            
        }else if from == "Landline"{
            
            if telephoneNumber != nil  && enteredAmount != nil{
                Call_CyrusApi(with: "Landline", rechargeType: operatorsModel.serviceType, amount: amount, operatorCode: operatorcode, dynamicnum: num, circle: circle)
            }else{
                Alert.showAlertError(on: self, message: "Fill All Details")
                
            }
            
        }else if from == "Insurance"{
            
            if telephoneNumber != nil  && enteredAmount != nil{
                Call_CyrusApi(with: "Insurance", rechargeType: operatorsModel.serviceType, amount: amount, operatorCode: operatorcode, dynamicnum: num, circle: circle)
            }else{
                Alert.showAlertError(on: self, message: "Fill All Details")
                
            }
            
        }else if from == "DTH"{
            
            if telephoneNumber != nil  && enteredAmount != nil{
                Call_CyrusApi(with: "DTH", rechargeType: operatorsModel.serviceType, amount: amount, operatorCode: operatorcode, dynamicnum: num, circle: circle)
            }else{
                Alert.showAlertError(on: self, message: "Fill All Details")
                
            }
            
        }else if from == "GAS"{
            
            if telephoneNumber != nil  && enteredAmount != nil{
                Call_CyrusApi(with: "GAS", rechargeType: operatorsModel.serviceType, amount: amount, operatorCode: operatorcode, dynamicnum: num, circle: circle)
            }else{
                Alert.showAlertError(on: self, message: "Fill All Details")
                
            }
            
        }
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //backButton(title: "Payment Details")
            
            navigationController?.navigationBar.isHidden = false
            selectoperator.text = selectedProvider
            serviceTitle.text = selectedServiceTitle
            telephoneNumber.placeholder = placholderText
            selectoperator.isUserInteractionEnabled = false
            
            telephoneNumber.keyboardType = .numberPad
            enteredAmount.keyboardType = .numberPad
            
            
            
        }
        
        func Call_CyrusApi(with:String,rechargeType:String,amount:String,operatorCode:String,dynamicnum:String,circle:String) {
            
            let baseUrl = APIConstants.BaseURL
            let fullurl = baseUrl+"user/recharge/\(with)"
            guard let operators = Foundation.URL(string:fullurl) else {return}
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = format.string(from: date)
            let dict = ["Type":rechargeType,"amount":amount,"operator":operatorCode,"number":dynamicNum,"circle":circle,"txnid":timestamp]
            
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
        
        
    }

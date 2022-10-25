//
//  EnterAmountScreen.swift
//  SwiftQRScanner_Example
//
//  Created by George Praneeth on 10/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import ObjectiveC
import Foundation
import UIKit
import SwiftMessages
import BLTNBoard

class EnterAmountScreen:UIViewController {
    
    @IBOutlet weak var intialLetter: UIImageView!
    
    @IBOutlet weak var sendername: UILabel!
    
    @IBOutlet weak var upiid: UILabel!
    
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var paymentBtn: UIButton!
    
    var scannedData:String = ""
    var recieverUPIID:String = ""
    var merchantName:String = ""
    var merchantcode:String = ""
    var from:String = ""
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return .portrait
        
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
   // var appInvoke = AIHandler()
    
    private lazy var board_manager:BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Complete your Payment")
        //item.image = UIImage(named: "addbank")
        item.actionButtonTitle = "GPay"
//        item.actionButtonTitle = "PhonePe"
//        item.actionButtonTitle = "Paytm"
        item.alternativeButtonTitle = "Paytm"
        
//        item.actionButton?.addTarget(self, action: #selector(actionBtn_gpay), for: .touchUpInside)
//        item.actionButton?.addTarget(self, action: #selector(actionBtn_phonepe), for: .touchUpInside)
//        item.actionButton?.addTarget(self, action: #selector(action_Btn_paytm), for: .touchUpInside)
    
        item.actionHandler = { [self] response1 in

            let enteredAmount = amount.text ?? ""

            print("1st Tapped")
            print("1st response ",response1)
            initiatePayment(provider: "gpay", amount: enteredAmount)

        }

        item.actionHandler = { [self] response2 in

            let enteredAmount = amount.text ?? ""

             initiatePayment(provider: "PhonePe", amount: enteredAmount)
            print("2nd Tapped")
            print("2nd response ",response2)

        }

        item.actionHandler = { [self] response3 in

            let enteredAmount = amount.text ?? ""

            initiatePayment(provider: "paytm", amount: enteredAmount)
            print("3rd Tapped")
            print("3rd response ",response3)
        }
        
        return BLTNItemManager(rootItem: item)
    }()
    
    @objc func actionBtn_gpay() {
        
        
        let enteredAmount = amount.text ?? ""
        initiatePayment(provider: "gpay", amount: enteredAmount)
        print("Phonepe Tapped")
        print("1st response ")
        
        
    }
    
    
    @objc func actionBtn_phonepe() {
        
        let enteredAmount = amount.text ?? ""
        initiatePayment(provider: "phonepe", amount: enteredAmount)
        print("Phonepe Tapped")
        print("2nd response ")
        
    }
    
    @objc func action_Btn_paytm() {
        
        let enteredAmount = amount.text ?? ""
        initiatePayment(provider: "paytm", amount: enteredAmount)
        print("paytm Tapped")
        print("3rd response")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton(title: "EnterAmount")
        
        amount.keyboardType = .numberPad
        
       // paymentBtn.addGradient()
        
        paymentBtn.layer.cornerRadius = 20
        
        sendername.font = UIFont.boldSystemFont(ofSize: 17)
        
        print("ScannedData from EnterAmountScreen ",scannedData)
        
        if from == "UPI" {
            
            let upi = scannedData.split(separator: "=")
            
            let splitdata = scannedData.split(separator: "&")
            
            let name = scannedData.components(separatedBy: CharacterSet.controlCharacters)
            
            print("upi Data: ",name)
            
            let splittedUpi = upi[1].split(separator: "&")
            
            let splitname =   upi[2].split(separator: "&")
            
            
            
            let Phoneperange = scannedData.range(of: "PhonePeMerchant")
            
            print("Phoneperange: ",Phoneperange!)
            
            let letters = NSCharacterSet.letters
           
            let phrase = upi.description
            let prange = phrase.rangeOfCharacter(from: letters)
          
            // range will be nil if no letters is found
            if let test = prange {
                
            let convertedRange = NSRange(test, in: phrase)
                print("rangefrom phrase: ",convertedRange.description)
                print("letters found")
            }
            else {
               print("letters not found")
                
            }
            
            let title = upi.description
            let range = title.range(of: "PhonePeMerchant")
            
            print("splitdata: ",splitdata)
            print("upi ",upi)
            print("splittedUpi ",splittedUpi)
            print("splitname ",splitname)
            
            guard let upiIDOptional =  splittedUpi.first else {return}
            guard let nameOptional = splitname.first else {return}
            
            let UPIID = upiIDOptional.description
            let merchant_Name = nameOptional.description.replacingOccurrences(of: "%20", with: " ")
            
            recieverUPIID = UPIID
            merchantName = merchant_Name
           
            upiid.text = "UPI ID: \(UPIID)"
            sendername.text = "Name: \(merchantName)"
            
            let intial = merchant_Name.initials
            intialLetter.ImageViewRoundCorners(corners: .allCorners, radius: 10)
            intialLetter.setImage(string: intial)
            
            
        }else if from == "Bharat" {
            
            let pop = scannedData.index(scannedData.startIndex, offsetBy: 8)
            
            let m = scannedData.split(separator: "M")
            
            print("split ",m)
            
            let BharatString  = scannedData
            
            let index = BharatString.index(BharatString.startIndex, offsetBy: 5)
            let mySubstring = BharatString[..<index]
            
            print("subString ",mySubstring)
            print("POP ",pop)
            print("from enter ",scannedData)
            
        }
     
        let open = scannedData
        
        let urlDecoder = open.removingPercentEncoding
        
        print("urlDecoder ",urlDecoder!)
        
    }
    
    @IBAction func payment(_ sender: Any) {
        
//        let vc = HalfScreenViewController()
//        vc.modalPresentationStyle = .overCurrentContext
//        // Keep animated value as false
//        // Custom Modal presentation animation will be handled in VC itself
//        self.present(vc, animated: false)
        
        print("Amount",amount.text!)
        
        if amount.text == "" {
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: "Please Enter Amonut")
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
        }else{
            
            let pay:PaymentOptionsVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "paymentOptions") as! PaymentOptionsVC
            pay.scannedData = scannedData
            pay.enteredAmount = amount.text ?? ""
            pay.view.isOpaque = false
            pay.view.backgroundColor = .white
            pay.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(pay, animated: true)
            
        }
        
    }
    
    func am_Is_Available(result:String,provider:String) {
        
        let modified_Result = result.replacingOccurrences(of: "upi://", with: "\(provider)://upi/")
        
        guard let url = URL(string: modified_Result) else {return}
        
        print("url sent to gpay: ",url)
        
        UIApplication.shared.open(url) { response in
            
            print("iscomplete ",response)
            
        }
        
    }
    
    func initiatePayment(provider:String,amount:String) {
        
        let result = scannedData
        let modified_Result = result.replacingOccurrences(of: "upi://", with: "\(provider)://upi/")
        let open = modified_Result+"&am=\(amount)"
        guard let modified_url = URL(string: open) else {return}
        
        print("modified_url ",modified_url)
        
        if UIApplication.shared.canOpenURL(modified_url) {
            
          UIApplication.shared.open(modified_url)
        } else {
          NSLog("Can't open upi on this device.")
        }
        
        
        if #available(iOS 13.0, *) {
            let sessions = UIApplication.shared.openSessions
            print("iscomSessions ",sessions)
        } else {
            // Fallback on earlier versions
        }
        
    }
}

extension UIButton {
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)
        gradientLayer.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

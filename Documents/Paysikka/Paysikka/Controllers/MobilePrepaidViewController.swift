//
//  MobilePrepaidViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 12/08/22.
//

import UIKit

class MobilePrepaidViewController: UIViewController {

    var ischecked:Bool = false
    var postIsCheck:Bool = false
    var typeofplan:String = "Prepaid-Mobile"
    
    static var globalOperatorName:String!
    static var selectedOperatorCode:String!
    static var globalCircleName:String!
    static var selectedCircleName:String!
    static var selectedCircleCode:String!
    static var selectedAmount:String!
    
    var operatorName:String!
    var circleName:String!
    
    var operatorCode:String!
    var circlecode:String!
    var selectedPlanAmount:String!
    
    
    var plansModel:[BrowsePlansModel] = []
    var plansSet = Set<String>()
    var plansArr:[String] = []

    @IBOutlet weak var enteredNumber:UITextField!
    
    @IBOutlet weak var operatorimage:UIImageView!
    
    @IBOutlet weak var prepaidRecharge: UIButton!
    
    @IBOutlet weak var postpaidRecharge: UIButton!
    
    @IBOutlet weak var operatorField: UITextField!
    
    @IBOutlet weak var operatorsStack: UIStackView!
    
    @IBOutlet weak var circlesStack: UIStackView!
    
    @IBOutlet weak var circlesLabel: UILabel!

    @IBOutlet weak var providertype: UISegmentedControl!
    
    @IBOutlet weak var planAmount: UITextField!
    
    @IBOutlet weak var operatorsLbl: UILabel!
    
    @IBAction func providertype(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
           typeofplan = "Prepaid-Mobile"
        case 1:
            typeofplan = "Postpaid-Mobile"
        default:
            break
        }
        
    }
    @IBAction func browseplansTapped(_ sender: Any){
       
        if operatorName != nil {
            LoadingOverlay.shared.showOverlay()
            print("Operator_name: ",operatorName)
            callPlans(selected:operatorName) { result in
                print("result from plans: ",result)
                
                if result{
                    
                    DispatchQueue.main.async { [self] in
                        LoadingOverlay.shared.hideOverlayView()
                        let plans = PlansTabViewcontroller()
                        plans.plansModel = plansModel
                        plans.plansArr = plansArr
                        print("push to plans: ")
                        self.navigationController?.pushViewController(plans, animated: true)
                        
                    }
                }
            }
            
        }else {
            Alert.showAlertError(on: self, message: "Please Select your Operator")
        }
        
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
    
        if planAmount.text == " " {
            Alert.showAlertError(on: self, message: "Please Select your Plan Amount")
        }else if (circlecode == nil) {
            Alert.showAlertError(on: self, message: "Please Select Your Circle")
        }else if enteredNumber.text == " "{
            Alert.showAlertError(on: self, message: "Please Enter Your Number")
        }else{
            let addChargesVC:AddChargesVC = UIStoryboard(name: "NewHome", bundle: nil).instantiateViewController(withIdentifier: "AddChargesVC") as! AddChargesVC
            if let amount = planAmount.text {
                addChargesVC.Call_ExtraPrice(selected:amount)
            }
            print("circleCode: ",circlecode,"enteredText",planAmount.text,"operatorName: ",operatorName)
            
            addChargesVC.with = "mobile"
            addChargesVC.circle = circlecode
            addChargesVC.phonenum = enteredNumber.text ?? ""
            addChargesVC.operatorName = operatorName
            addChargesVC.amount = planAmount.text ?? ""
            self.navigationController?.pushViewController(addChargesVC, animated: true)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MobilePrepaid ",#function)
        navigationController?.navigationBar.isHidden = false
        print("The",navigationController?.navigationBar.isHidden)
        
        operatorName = MobilePrepaidViewController.globalOperatorName
        operatorCode = MobilePrepaidViewController.selectedOperatorCode
        circleName = MobilePrepaidViewController.globalCircleName
        circlecode = MobilePrepaidViewController.selectedCircleCode
        selectedPlanAmount = MobilePrepaidViewController.selectedAmount
        
        if MobilePrepaidViewController.globalOperatorName != nil {
            operatorsLbl.text = operatorName
        }
        if MobilePrepaidViewController.globalCircleName != nil {
           circlesLabel.text = circleName
        }
        
        planAmount.text = selectedPlanAmount
        
        print("GlobalOperatorName: ",MobilePrepaidViewController.globalOperatorName)
        print("GlobalCircleName: ",MobilePrepaidViewController.globalCircleName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        
        operatorsStack.roundCorners(.allCorners, radius: 5)
        circlesStack.roundCorners(.allCorners, radius: 5)
        
        operatorsStack.layer.borderColor = UIColor.black.cgColor
        circlesStack.layer.borderColor = UIColor.black.cgColor
        
        let OGuesture = UITapGestureRecognizer(target: self, action: #selector(operatotTapped))
        operatorsStack.addGestureRecognizer(OGuesture)
        
        let CGuesture = UITapGestureRecognizer(target: self, action: #selector(circlesTapped))
        circlesStack.addGestureRecognizer(CGuesture)
        
        planAmount.addImagetoTextField()
        
        backButton(title: "Operators")
        
        print("GlobalOperatorName: ",MobilePrepaidViewController.globalOperatorName)
        print("GlobalCircleName: ",MobilePrepaidViewController.globalCircleName)
        
    }
    
    
    func planAmount(amount:String){ 
         planAmount.text = amount
    }
    
    @objc func operatotTapped(){
        
        let provider:ProviderTBVViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "BillTBV") as! ProviderTBVViewController
        provider.from = typeofplan
        print("typeofplan push : ",typeofplan)
        provider.modalPresentationStyle = .pageSheet
        provider.title = "Select Your Operator"
        let navController = UINavigationController(rootViewController: provider)
        navController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "x", style: .done, target: self, action: #selector(close))
        self.navigationController?.present(navController, animated: true)
    
    }
    
    @objc func close(){
        print(#function)
    }
    
    @objc func circlesTapped(){
        
        let provider:ProviderTBVViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "BillTBV") as! ProviderTBVViewController
        provider.from = "circles"
//        provider.view.backgroundColor = .clear
//        provider.modalPresentationStyle = .popover
        provider.title = "Select Your Circle"
        let navController = UINavigationController(rootViewController: provider)
        self.navigationController?.present(navController, animated: true)
    
    }
    
    
    @objc func prepaidButtonTapped(_ sender:UIButton) {
        
        prepaidRecharge.isSelected = false
        postpaidRecharge.isSelected = false
        sender.isSelected = true
       // prepaidRecharge.isSelected = !prepaidRecharge.isSelected
        ischecked = prepaidRecharge.isSelected
        
       let state = prepaidRecharge.state
       print("Prepaid ",state)
        
        if sender.isSelected == true {
            prepaidRecharge.setImage(UIImage(named: "selected"), for: .normal)
        }else{
            ischecked = false
            sender.isSelected = false
            prepaidRecharge.setImage(UIImage(named: "unselected"), for: .normal)
        }
        
        
    }
    
    @objc func postpaidButtonTapped(_ sender:UIButton) {
        prepaidRecharge.isSelected = false
        postpaidRecharge.isSelected = false
        sender.isSelected = true
       // postpaidRecharge.isSelected = !postpaidRecharge.isSelected
        postIsCheck = postpaidRecharge.isSelected
        
        let state = postpaidRecharge.state
        print("Postpaid State ",state)
        
        if sender.isSelected == true {
            
            postpaidRecharge.setImage(UIImage(named: "selected"), for: .normal)
        }else{
            postIsCheck = false
            sender.isSelected = false
            postpaidRecharge.setImage(UIImage(named: "unselected"), for: .normal)
        }
        
        print("postpaidButtonTapped ischecked: ",postIsCheck)
        print("prepaidButtonTapped ischecked: ",ischecked)
        
    }
    
    /// Calling function to get plans
    /// - Parameters:
    ///   - selected: operatorSelectedbyUser
    ///   - completed: return a bool whether its completed task for navigating to plansVC
    func callPlans(selected:String,completed:@escaping (_ result:Bool) -> Void){
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/plans/\(selected)/prepaid"
        guard let percentaddedUrl = fullurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let operators = Foundation.URL(string:percentaddedUrl) else {return}
        var url = URLRequest(url: operators)
        url.httpMethod = "GET"
        //  url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSArray
                        
                        for i in recieved {
                            
                            //  print("i from loop: ",i)
                            let browsePlansDdict = BrowsePlansModel(fromDictionary: i as? [String:Any] ?? ["":""])
                            plansModel.append(browsePlansDdict)
                            plansSet.update(with: browsePlansDdict.type)
                            print("plans: ",browsePlansDdict.type)
                        }
                        
                        let plansarr = [String](plansSet)
                        plansArr = plansarr
                        completed(true)
                        
                        print("after plansupdate: ",plansArr.count)
                        print("plantypes from api: ",plansSet.count)
                        
                        let FilteredOperators = plansModel.filter({$0.type == "Truly Unlimited"})
                        
                        print("FilteredOperators from Api: ",FilteredOperators.count,FilteredOperators.forEach({ plan in
                            print("plans: ",plan.amount)
                        }))
                        
                        DispatchQueue.main.async {
                            
                        }
                        
                        print("success from Operators ",recieved)
                        
                        
                    }catch{
                        completed(false)
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        completed(false)
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
                        completed(false)
                        print("there's a catch from operators")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    func Call_Operator() {
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/operators"
        
        guard let operatorUrl = Foundation.URL(string:fullurl) else {return}
        
        var url = URLRequest(url: operatorUrl)
        url.httpMethod = "POST"
        //  url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("success ",recieved)
                        
                        
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
    
    
}

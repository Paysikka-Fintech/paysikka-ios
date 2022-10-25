//
//  DTHTBVControllerViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 16/08/22.
//

import UIKit

class ProviderTBVViewController: UIViewController {
    
    @IBOutlet weak var providersTBV: UITableView!
    
    @IBOutlet weak var closeLbl: UILabel!
    
    var from:String = ""
    var plan:String = ""
    var operatorsModel: [OperatorsModel] = []
    var circlesModel:[CirclesModel] = []
    var prefersTitle:Bool?
    var selectedoparatorCode:String = ""
    var selectedCircleCode:String = ""
    
//    var providerNames = ["","",""]
//    let elecProviderImages = ["Tsspdcl_logo"]
//    let elecProviderNames = ["TSSPDCL","TRIPURA","West Bengal Electricity","UPPCL (URBAN) - UTTAR PRADESH","Tata Power - DELHI"]
//    let landlineProviderImages = ["","",""]
//    let landlineprovidersNames = ["Tata Docomo CDMA Landline","BSNL landline - Individiual","BSNL landline - Corporate","Airtel"]
  
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        closeLbl.isHidden = true
        
        if from == "operators"{
            print("from operators ",from)
            Call_Operator(selected: "airtel")
        }else if from == "circles"{
            Call_Circles()
        }else{
        Call_Operator(selected: from)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.title = "Select Your Operator"
        navigationController?.navigationBar.prefersLargeTitles = prefersTitle ?? false
        
        print("From: ",from)
        
        providersTBV.delegate = self
        providersTBV.dataSource = self
        providersTBV.register(UINib(nibName: "ProviderTableViewCell", bundle: nil), forCellReuseIdentifier: ProviderTableViewCell.reuseidentifier)
       
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        closeLbl.isUserInteractionEnabled = true
        closeLbl.addGestureRecognizer(gesture)
        
        
    }
    
    @objc func closeTapped() {
        
        self.navigationController?.popToRootViewController(animated: true)
      //  self.dismiss(animated: true)
        
    }
    
}

extension ProviderTBVViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        print("service: ",from)
        
        if from == "circles"{
            count = circlesModel.count
        }else if from == "Prepaid-Mobile" || from == "Postpaid-Mobile"{
            
            count = operatorsModel.filter({$0.serviceType == from}).count
          
            print("Count from numberOfRows: ",count)
        }else if from == "DTH"{
            
            count = operatorsModel.filter({$0.serviceType == "DTH"}).count
          
        }else if from == "Electricity"{
            
            print("Count from numberOfRows elec: ",count)
            count = operatorsModel.filter({$0.serviceType == "Electricity"}).count
        
        }else if from == "Landline"{
            
            count = operatorsModel.filter({$0.serviceType == "Landline"}).count
            
        }else if from == "Insurance"{
            
            count = operatorsModel.filter({$0.serviceType == "Insurance"}).count
        }else if from == "GAS"{
            
            count = operatorsModel.filter({$0.serviceType == "GAS"}).count
        }else if from == "Water"{
            
            count = operatorsModel.filter({$0.serviceType == "Water"}).count
            
        }else if from == "Loan Repayment"{
            
            count = operatorsModel.filter({$0.serviceType == "Loan Repayment"}).count
            
        }
        
        print("tableView Count: ",count,"Circle model Count ",operatorsModel.count)
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:ProviderTableViewCell.reuseidentifier, for: indexPath) as! ProviderTableViewCell
        
        print("from cell ",from)
        
        if from == "circles"{
            
            cell.providerTitle.text = circlesModel[indexPath.row].area
            cell.providerimage.isHidden = true
            
        }else if from == "Prepaid-Mobile"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "Postpaid-Mobile"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "DTH"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "Electricity" {
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "Landline"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "Insurance"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "GAS"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "Water"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }else if from == "Loan Repayment"{
            cell.providerimage.downloaded(from: operatorsModel[indexPath.row].imageUrl)
            cell.providerTitle.text = operatorsModel[indexPath.row].operatorName
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = providersTBV.cellForRow(at: indexPath) as? ProviderTableViewCell
        
        let cellname = cell?.providerTitle.text
        
        print("cell name",cellname ?? "")
    
        if from == "circles"{
            
            guard let name = cellname else {return}
            getValuesforcircles(value: name, index: indexPath)
            
        }else if from == "Prepaid-Mobile" || from == "Postpaid-Mobile"{
            
            guard let name = cellname else {return}
            getValuesforOperator(value:name, index: indexPath)
            
        }else if from == "Electricity"{
            
            let electrictyVC :LandlineViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "LandlineViewController") as! LandlineViewController
            electrictyVC.selectedProvider = cellname ?? ""
            electrictyVC.operatorcode = operatorsModel[indexPath.row].operatorCode
            electrictyVC.operatorsModel = operatorsModel[indexPath.row]
            electrictyVC.selectedServiceTitle = "Pay Your Electricity Bill"
            electrictyVC.placholderText = "Unique ID"
            electrictyVC.from = from
            self.navigationController?.pushViewController(electrictyVC, animated: true)
            
        }else if from == "Landline"{
            
            let landlineVC :LandlineViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "LandlineViewController") as! LandlineViewController
            landlineVC.selectedProvider = cellname ?? ""
            landlineVC.selectedServiceTitle = "Pay your Landline Bill"
            landlineVC.placholderText = "STD Number"
            landlineVC.operatorsModel = operatorsModel[indexPath.row]
            landlineVC.from = from
            landlineVC.operatorcode = operatorsModel[indexPath.row].operatorCode
            self.navigationController?.pushViewController(landlineVC, animated: true)
            
        }else if from == "Insurance"{
            
            let broadbandVC :LandlineViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "LandlineViewController") as! LandlineViewController
            broadbandVC.selectedProvider = cellname ?? ""
            broadbandVC.selectedServiceTitle = "Pay your Insurance Bill"
            broadbandVC.placholderText = "Account Num"
            broadbandVC.operatorsModel = operatorsModel[indexPath.row]
            broadbandVC.from = from
            broadbandVC.operatorcode = operatorsModel[indexPath.row].operatorCode
            self.navigationController?.pushViewController(broadbandVC, animated: true)
            
        }else if from == "DTH"{
               
            let dthVC :LandlineViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "LandlineViewController") as! LandlineViewController
            dthVC.selectedProvider = cellname ?? ""
            dthVC.selectedServiceTitle = "Pay Your DTH Bill"
            dthVC.placholderText = "Smart Number"
            dthVC.operatorsModel = operatorsModel[indexPath.row]
            dthVC.from = from
            dthVC.operatorcode = operatorsModel[indexPath.row].operatorCode
            self.navigationController?.pushViewController(dthVC, animated: true)
             
        }else if from == "GAS"{
            
            let gasVC :LandlineViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "LandlineViewController") as! LandlineViewController
            gasVC.selectedProvider = cellname ?? ""
            gasVC.selectedServiceTitle = "Pay Your GAS Bill"
            gasVC.placholderText = "Service Provider"
            gasVC.operatorsModel = operatorsModel[indexPath.row]
            gasVC.from = from
            gasVC.operatorcode = operatorsModel[indexPath.row].operatorCode
            self.navigationController?.pushViewController(gasVC, animated: true)
            
        }else if from == "Water"{
            
            let gasVC :LandlineViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "LandlineViewController") as! LandlineViewController
            gasVC.selectedProvider = cellname ?? ""
            gasVC.selectedServiceTitle = "Pay Your Water Bill"
            gasVC.placholderText = "Service Provider"
            gasVC.operatorsModel = operatorsModel[indexPath.row]
            gasVC.from = from
            gasVC.operatorcode = operatorsModel[indexPath.row].operatorCode
            self.navigationController?.pushViewController(gasVC, animated: true)
            
            
        }else if from == "Loan Repayment"{
            
            let loan :LandlineViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "LandlineViewController") as! LandlineViewController
            loan.selectedProvider = cellname ?? ""
            loan.selectedServiceTitle = "Loan Repayment"
            loan.placholderText = "Account Num"
            loan.operatorsModel = operatorsModel[indexPath.row]
            loan.from = from
            loan.operatorcode = operatorsModel[indexPath.row].operatorCode
            self.navigationController?.pushViewController(loan, animated: true)
            
        }
        
    }
    
    func getValuesforcircles(value:String,index:IndexPath){
          
        MobilePrepaidViewController.globalCircleName = value
        MobilePrepaidViewController.selectedCircleCode = circlesModel[index.row].code
       // navigationController?.popViewController(animated: true)
        self.dismiss(animated: true){ [self] in
        MobilePrepaidViewController.globalCircleName = value
        MobilePrepaidViewController.selectedCircleCode = circlesModel[index.row].code
            
        }
    }
    
    func getValuesforOperator(value:String,index:IndexPath){
        
        MobilePrepaidViewController.globalOperatorName = value
        MobilePrepaidViewController.selectedOperatorCode = operatorsModel[index.row].operatorCode
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}
        
extension ProviderTBVViewController {
    
    func Call_Operator(selected:String) {
        
        LoadingOverlay.shared.showOverlay()
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/operators/\(selected)"
        guard let operators = Foundation.URL(string:fullurl) else {return}
        var url = URLRequest(url: operators)
        url.httpMethod = "GET"
        //  url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSArray
                        
                        for i in recieved {
                            
                           //  print("i from loop: ",i)
                            let operatorsdict = OperatorsModel(fromDictionary: i as? [String : Any] ?? ["":""])
                           // print("Name ",operatorsdict.operatorName)
                            operatorsModel.append(operatorsdict)
                           // print("Count ",operatorsModel.count)
                          
                        }
                        
                        let filteredprepaid = operatorsModel.filter({$0.serviceType == "Prepaid-Mobile"})
                        let filteredBroadband = operatorsModel.filter({$0.serviceType == "Broadband"})
                        let filteredDTH = operatorsModel.filter({$0.serviceType == "DTH"})
                        let filteredLandline = operatorsModel.filter({$0.serviceType == "Landline"})
                        if from == "Electricity"{
                            
                        }
                        let filteredElectricity = operatorsModel.filter({$0.serviceType == "Electricity"})
                        
                        print("FilteredOperators from Api: ",filteredprepaid.count,"filteredBroadband from Api: ",filteredBroadband.count,"filteredDTH from Api: ",filteredDTH.count,"filteredLandline from Api: ",filteredLandline.count,"filteredElectricity from Api: ",filteredElectricity.count)
                        
                        DispatchQueue.main.async { [self] in
                        providersTBV.reloadData()
                            
                        }
                        
                      //  print("success from Operators ",recieved)
                        
                        
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
    
    func Call_Circles() {
        
        LoadingOverlay.shared.showOverlay()
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/circles"
        guard let circles = Foundation.URL(string:fullurl) else {return}
        
        var url = URLRequest(url: circles)
        url.httpMethod = "GET"
        //  url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSArray
                        
                        for i in recieved {
                        
                            let circlessdict = CirclesModel(fromDictionary: i as? [String : Any] ?? ["":""])
                            circlesModel.append(circlessdict)
                            
                        }
                        DispatchQueue.main.async { [self] in
                        providersTBV.reloadData()
                        }
                        
                        print("success from Circles ",recieved)
                        
                        
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
                        print("there's a catch from Circles")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    
}

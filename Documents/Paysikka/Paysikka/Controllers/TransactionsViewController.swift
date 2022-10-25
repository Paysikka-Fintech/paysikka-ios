//
//  TransactionsViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 10/07/22.
//

import UIKit
import VegaScrollFlowLayout


class TransactionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

{
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        call_TransactionsData()
    }

    
    var transactionsData:[TransactionModel] = []
    
    private let itemHeight: CGFloat = 100
    private let lineSpacing: CGFloat = 20
    private let xInset: CGFloat = 20
    private let topInset: CGFloat = 10
    
    
    var TransactionsCView:UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:TranasctionCell.identifier, for: indexPath) as! TranasctionCell
//        cell.transaction_Message.text = "Hello"
        
        let type = transactionsData[indexPath.row].type ?? ""
        
        print("Transaction Type ",transactionsData[indexPath.row].type)
        
        if type.elementsEqual("RM"){
            
            cell.gramsadded.text = " - \(transactionsData[indexPath.row].grams ?? 0.0) gms"
            cell.gramsadded.textColor = UIColor.red
            
        }else {
            
            cell.gramsadded.text =  " + \(transactionsData[indexPath.row].grams ?? 0.0) gms"
            cell.gramsadded.textColor = UIColor.green
        }
        
        cell.transaction_Message.text = transactionsData[indexPath.row].message
        
        cell.transaction_Message.adjustsFontSizeToFitWidth = true
        cell.transactionID.text = "Transaction ID: \(transactionsData[indexPath.row].transactionid ?? "0")"
      //  cell.transactionID.adjustsFontSizeToFitWidth = true
        cell.gramsadded.adjustsFontSizeToFitWidth = true
        
        print("Transactions Data from cell  message ",transactionsData[indexPath.row].message)
        print("Transactions Data from cell transactionid ",transactionsData[indexPath.row].transactionid)
        print("Transactions Data from cell grams ",transactionsData[indexPath.row].grams)
        
        
        return cell
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton(title:"Transactions")
        self.tabBarController?.tabBar.isHidden = false
        
        let layout = VegaScrollFlowLayout()
        TransactionsCView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let nib = UINib(nibName:"TranasctionCell", bundle: nil)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        TransactionsCView.register(nib, forCellWithReuseIdentifier:TranasctionCell.identifier)
        layout.minimumLineSpacing = lineSpacing
        layout.itemSize = CGSize(width:itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 10, right: 0)
        layout.scrollDirection = .vertical
        TransactionsCView.delegate = self
        TransactionsCView.dataSource = self
        TransactionsCView.collectionViewLayout.invalidateLayout()
        view.addSubview(TransactionsCView)
        view.constrainToEdges(TransactionsCView)
        
//        NSLayoutConstraint.activate([
//
//            TransactionsCView.topAnchor.constraint(equalTo:view.topAnchor),
//            TransactionsCView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            TransactionsCView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            TransactionsCView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//        ])
    
    }
    
}

extension TransactionsViewController {
    
    func call_TransactionsData() {

        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/transactions"
        guard let transactions = URL(string: fullurl) else {return}

        guard let auth = UserDefaults.standard.string(forKey: "accessToken") else {return}
        
        print("accesssToken ",auth)
        
        var url = URLRequest(url: transactions)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.allHTTPHeaderFields = ["Authorization":auth]

        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in

            guard let data = dataResponse else {return}

            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    if data != nil {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                        
                            for x in recieved {
                                
                                let transaction = TransactionModel(fromDictionary: x as? [String:Any] ?? ["":""])
                                transactionsData.append(transaction)
                               
                            }
                           
                            print("success ",recieved)
                            //print("transaction ",transactionsData[0].transactionid,transactionsData[0].message)
                            
                            DispatchQueue.main.async { [self] in
                              
                                TransactionsCView.reloadData()
                                
                            }
                            
                       
                        }
                        catch {
                            print("there's a catch")
                        }
                        
                    }else {
                        
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
                    
                }else {
                    
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

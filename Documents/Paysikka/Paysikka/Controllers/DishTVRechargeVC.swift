//
//  DishTVRechargeVC.swift
//  Paysikka
//
//  Created by George Praneeth on 20/09/22.
//

import UIKit

class DishTVRechargeVC: UIViewController {
    
    @IBOutlet weak var selectProvider: UITextField!
    
    @IBOutlet weak var accountID: UITextField!
    
    var selectedProvider:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        selectProvider.text = selectedProvider
        selectProvider.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    

}

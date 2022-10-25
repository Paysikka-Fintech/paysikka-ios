//
//  ElectricityViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 16/08/22.
//

import UIKit

class ElectricityViewController: UIViewController {

    @IBOutlet weak var selectoperator: UITextField!
    
    @IBOutlet weak var uniqueID: UITextField!
    
    @IBOutlet weak var providerName: UILabel!
    
    var selectedProvider:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        selectoperator.text = selectedProvider
        selectoperator.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        
        
        
        
        
        
    }
    
}

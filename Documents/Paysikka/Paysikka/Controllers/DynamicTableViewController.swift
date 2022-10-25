//
//  DynamicTableViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 21/09/22.
//

import UIKit

class DynamicTableViewController: UIViewController {
    
    var DynamicPlans:[BrowsePlansModel] = []
    
    var setTitle:String?
    
    @IBOutlet weak var dynamicTableView: UITableView!
    /*
    convenience init(index: Int,dynamicplan:[BrowsePlansModel]) {
       
        self.init(title: "View \(index)", content: "\(index)", dynamicplan:dynamicplan)
    }

    convenience init(title: String,dynamicplan:[BrowsePlansModel]) {
        self.init(title: title, content: title,dynamicplan: dynamicplan)

    }
    
    init(title: String, content: String,dynamicplan:[BrowsePlansModel]){
        setTitle = content
        super.init(nibName: nil, bundle: nil)
       
        self.DynamicPlans = dynamicplan
        print("Dynamic--",dynamicplan)
        
//        var label = UILabel(frame: .zero)
//        label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
//        label.textColor = UIColor(red: 95 / 255, green: 102 / 255, blue: 108 / 255, alpha: 1)
//        label.textAlignment = .center
//
//        print("init DTVC",content)
//        label.text = content
//        label.sizeToFit()
//
//        view.addSubview(label)
//        view.constrainToEdges(label)
//        view.backgroundColor = .white
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        dynamicTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton(title: "Plans")
        navigationController?.navigationBar.isHidden = false

        let nib = UINib(nibName:"PlansTableViewCell", bundle: nil)
        dynamicTableView.register(nib, forCellReuseIdentifier: PlansTableViewCell.identifier)
        
        dynamicTableView.dataSource = self
        dynamicTableView.delegate = self
        
        print("setTitle: ",setTitle ?? "")
        
    }
    
    
}

extension DynamicTableViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DynamicPlans.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = dynamicTableView.dequeueReusableCell(withIdentifier: PlansTableViewCell.identifier, for: indexPath) as? PlansTableViewCell else {return UITableViewCell()}
        
        let data = DynamicPlans[indexPath.row].data ?? ""
        let perday = DynamicPlans[indexPath.row].per ?? ""
        
        cell.planAmountLbl.text = "₹ "+DynamicPlans[indexPath.row].amount
        cell.plandescription.text = DynamicPlans[indexPath.row].descriptionField
        cell.planValidity.text = DynamicPlans[indexPath.row].validity
        cell.planDataperday.text = data+perday
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let planAmount = DynamicPlans[indexPath.row].amount
        
        MobilePrepaidViewController.selectedAmount = planAmount
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
}

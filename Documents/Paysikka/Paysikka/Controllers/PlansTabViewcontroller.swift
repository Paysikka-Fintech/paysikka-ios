//
//  PalnsTabViewcontroller.swift
//  Paysikka
//
//  Created by George Praneeth on 24/09/22.
//

import UIKit
import Parchment

class PlansTabViewcontroller: PagingViewController, PagingViewControllerDataSource {

    var plansModel:[BrowsePlansModel] = []
    var plansSet = Set<String>()
    var plansArr:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dataSource = self
        menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
        includeSafeAreaInsets = false
        
    }
    
    func numberOfViewControllers(in pagingViewController: Parchment.PagingViewController) -> Int {
        
        return plansArr.count
    }
    
    func pagingViewController(_: Parchment.PagingViewController, viewControllerAt index: Int) -> UIViewController {
        
        var filtered = plansModel.filter({$0.type == plansArr[index]})
        filtered.append(plansModel[index])
       // print("filtered_: ",filtered[index].type,"plansModel: ",plansModel[index].type,plansArr[index])
        let dynamicTBV = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "DynamicTableViewController") as! DynamicTableViewController
        dynamicTBV.DynamicPlans = filtered
        dynamicTBV.setTitle = plansArr[index]
        
        return dynamicTBV
    }
    
    func pagingViewController(_: Parchment.PagingViewController, pagingItemAt index: Int) -> Parchment.PagingItem {
        print("pagingItemAt ",index)
        return PagingIndexItem(index: index, title: plansArr[index])
    }
    
    
}

//
//  PlansViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 16/09/22.
//

import UIKit
import Tabman
import Pageboy

class PlansViewController: TabmanViewController {
    
    var plansModel:[BrowsePlansModel] = []
    var plansSet = Set<String>()
    var plansArr:[String] = []
    
  //  private var viewControllers:[DynamicTableViewController] = []
    
    private var viewControllers = [UIViewController(),UIViewController(),UIViewController(),UIViewController(),UIViewController()]
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
             //     Call_Plans()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.dataSource = self
        
        // Create bar
        let bar = TMBar.TabBar()
        bar.scrollMode = .swipe
        bar.layout.transitionStyle = .progressive // Customize
        addBar(bar, dataSource: self, at: .top)
        
        print("PlansViewController Called",plansModel)
        
        
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: TabmanViewController.PageIndex) {
        print("current VC: ",pageboyViewController.currentViewController?.title)
    }

}

extension PlansViewController :PageboyViewControllerDataSource,TMBarDataSource {
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        print("plans Arr fom plansVC: ",plansArr.count)
        
        let title = "PAGE \(index)"
        
        let bar = TMBarItem(title:plansArr[index])
        
        return bar
        
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        print("plans Arr fom plansVC: ",plansArr)
        return viewControllers.count
    }
    
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        
//        var makeVC = makeViewController(name: plansArr[index])
//        print("makeVC ",makeVC)
        let vcs = viewControllers[index]
        vcs.view.backgroundColor = .random
        
        print("vc index before: ",vcs.pageboyPageIndex)
        print("title",vcs.navigationController?.title)
        print("vc index after: ",vcs.pageboyPageIndex)
        
        return vcs
        
//        var dynamic = viewControllers[index]
//        dynamic = DynamicTableViewController()
//        dynamic.DynamicPlans = plansModel.filter({$0.type == plansArr[index]})
//        return dynamic
//        let VCS = viewControllers.append(plansArr.forEach())
//        VCS.view.backgroundColor = .random
        
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
//    func makeViewController(name:String) -> UIViewController {
//
//        let dynamicVC = DynamicTableViewController()
//        dynamicVC.title = name
//            dynamicVC.DynamicPlans = plansModel
//        return (dynamicVC.storyboard?.instantiateInitialViewController())!
//
//       // plansModel.filter({$0.type == "Truly Unlimited"})
//
//    }
    
}

extension PlansViewController {
    
    func Call_Plans() {
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/plans/airtel/prepaid"
        guard let operators = Foundation.URL(string: fullurl) else {return}
        
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
                        
                        print("after plansupdate: ",plansArr.count)
                        print("plantypes from api: ",plansSet.count)
                        
                        let FilteredOperators = plansModel.filter({$0.type == "Truly Unlimited"})
                        
                        PlansViewController().reloadData()
                        
                        print("FilteredOperators from Api: ",FilteredOperators.count,FilteredOperators.forEach({ plan in
                           // print("plans: ",plan.amount)
                        }))
                        
                        DispatchQueue.main.async {
                            
                        }
                        
                        print("success from Operators ",recieved)
                        
                        
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

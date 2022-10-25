//
//  PaysikkaHome.swift
//  Paysikka
//
//  Created by George Praneeth on 05/07/22.
//

import Foundation
import UIKit
import AVFoundation
import SDWebImage

class PaysikkaHome:UIViewController {
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    var servicesSections:[ServicesModel] = []
    var categoriesSections:[CategoryModel] = []
    var banner_Images:[String] = []
    
    @IBOutlet weak var view_with_Image:UIView!
    @IBOutlet weak var down_view_with_collection:UIView!
    @IBOutlet weak var servicesCV: UICollectionView!
    @IBOutlet weak var bannersCV: UICollectionView!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var seriesCVConstraint: NSLayoutConstraint!
    @IBOutlet weak var phonesearchbar: UISearchBar!
    
    let headerId = "headerId"
    static let categoryHeaderId = "categoryHeaderId"
    
    override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicesCV.dataSource = self
        servicesCV.delegate = self
        
        view.backgroundColor = UIColor.init(named: "AppColor")
        view_with_Image.roundCorners(.bottomLeft, radius: 50)
        down_view_with_collection.roundCorners(.topRight, radius: 70)
        servicesCV.roundCorners(.topRight, radius: 40)
        bannersCV.roundCorners(.bottomLeft, radius: 40)
        
        servicesCV.showsVerticalScrollIndicator = false
        bannersCV.showsVerticalScrollIndicator = false
        
        let profileTapped = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileimage.isUserInteractionEnabled = true
        profileimage.addGestureRecognizer(profileTapped)
        
        flowBannerLayout()
        setupSeriesLayout()
        
        call_Banners()
        callCategories()
        
    }
    
    @objc func profileImageTapped(){
        
        let profile:ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profile, animated: true)
        
    }
    
    func flowBannerLayout(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:UIScreen.main.bounds.width/1, height:300)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top:2, left:0, bottom:2, right:0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        bannersCV.collectionViewLayout = createLayout()
        bannersCV.showsHorizontalScrollIndicator = false
        bannersCV.showsVerticalScrollIndicator = false
        bannersCV.delegate = self
        bannersCV.dataSource = self
        
      }
    
    func setupSeriesLayout(){
        //   let screenWidth = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top:10, left: 20, bottom:10, right: 20)
        layout.itemSize = CGSize(width:UIScreen.main.bounds.width/4, height:UIScreen.main.bounds.width/4)
        servicesCV.register(UINib(nibName: "SectionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SectionsCollectionViewCell.identifier)
        bannersCV.register(UINib(nibName: "BannerCVCell", bundle: nil), forCellWithReuseIdentifier: BannerCVCell.identifier)
        servicesCV.collectionViewLayout = createLayoutLBTA()
        servicesCV.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: PaysikkaHome.categoryHeaderId, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
    }
    
    func createcompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self](index, enviroment) -> NSCollectionLayoutSection? in
            
            return self?.createSectionFor(index: index, enviroment: enviroment)
        }
        return layout
    }
    
    func createSectionFor(index:Int , enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {

        print("section_Index",index)

        switch index {
        case 0:
            return createSecondSection()
        case 1:
            return createFirstSection()
        default:
            return createFirstSection()
        }
    }
    
    func createFirstSection() -> NSCollectionLayoutSection {
        print(#function)
        let inset: CGFloat = 2.5
    
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func createSecondSection() -> NSCollectionLayoutSection {
        
        print(#function)
        
        let inset: CGFloat = 2.5
        
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.6))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        //header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let inset: CGFloat = 2.5
        
        // 1
        // setup the item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // 2
        // setup the group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 3
        // setup the section
        let section = NSCollectionLayoutSection(group: group)
        
       // let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        // setup the header
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        section.boundarySupplementaryItems = [header]
        
        // 4
        // setup the layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func createLayoutLBTA() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 2
                //item.contentInsets.bottom = 16
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                
                return section
            } else if sectionNumber == 1 {
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(150)))
                item.contentInsets.trailing = 16
                item.contentInsets.bottom = 16
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: PaysikkaHome.categoryHeaderId, alignment: .topLeading)
                ]
                
                return section
            } else if sectionNumber == 2 {
                let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 32
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(125)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 16
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)))
                item.contentInsets.bottom = 16
                item.contentInsets.trailing = 16
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 32, leading: 16, bottom: 0, trailing: 0)
                return section
            }
        }
    }
    
    
    func call_Banners() {
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/banners"
        guard let banners = URL(string: fullurl) else {return}
        
        var url = URLRequest(url: banners)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSArray
                        
                        print("success ",recieved)
                        
                        for i in recieved {
                            
                            let banners = BannersModel(fromDictionary: i as? [String:Any] ?? ["":""])
                            
                            guard let bannnerIamge = banners.imageUrl else {return}
                            banner_Images.append(bannnerIamge)
                            
                        }
                        
                        DispatchQueue.main.async { [self] in
                            
                            bannersCV.reloadData()
                            // startTimer()
                        }
                        
                        print("Banner ",banner_Images[0],banner_Images.count)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        
                        print(recieved["message"] as Any)
                        
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
    
    func callCategories() {
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/categories"
        guard let categories = URL(string: fullurl) else {return}
        let auth = UserDefaults.standard.string(forKey: "accessToken") ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGVja3VzZXIiOnsidG9rZW4iOiJleUpoYkdjaU9pSklVekkxTmlJc0luUjVjQ0k2SWtwWFZDSjkuZXlKamFHVmphM1Z6WlhJaU9uc2libUZ0WlNJNkluUmhiR2xpSWl3aVpXMWhhV3dpT2lKemVXVmtkR0ZzYVdJME5rQm5iV0ZwYkM1amIyMGlMQ0oxYzJWeWFXUWlPalE0TXprc0ltVjRhWE4wWVc1alpTSTZkSEoxWlN3aWNHaHZibVVpT2pnek1Ea3hNRFkyTlRJc0ltTjFjM1J2YldWeWFXUWlPakV5TXprME5qYzFMQ0puYzE5MGIydGxiaUk2SWpJNVpqazJNR0UzTFRZd016TXRORE5qTVMwNFpqaG1MV0ptWkdVNFkyRXlOelF5WXlJc0ltdDVZM04wWVhSMWN5STZabUZzYzJVc0ltRmhaR2hoY201dklqb3dMQ0p3WVc1dWJ5STZJakFpTENKZmFXUWlPaUkyTXpOaVltSXdNV1UyWkROaE5XVmlNREUzTmprM1pXVWlMQ0prWVhSbElqb2lNakF5TWkweE1DMHdORlF3TkRvME9Eb3dNUzR3TlRGYUluMHNJbWxoZENJNk1UWTJORGcxT0RnNE1YMC5jTGdXV0xVdjhmVTgwZFZ4Z3pjSjBXRTlzS05FZVdDRS1Rb2VGc0Znb2h3In0sImlhdCI6MTY2NDg1ODg4MX0.hQb8f3-D9CU0v0DM_Z7OBH7-18-Tl9WBT7hka8PF0VA"
        print("Auth for categories: ",auth)
        var url = URLRequest(url: categories)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.allHTTPHeaderFields = ["Authorization":auth]
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSArray
                        
                        print("success ",recieved)
                        
                        DispatchQueue.main.async { [self] in
                            for i in recieved {
                                
                                let categories = CategoryModel(fromDictionary: i as? [String:Any] ?? ["":""])
                                categoriesSections.append(categories)
                            
                            }
                            servicesCV.reloadData()
                         
                        }
                        
                  
                        
                      //  let categoriesSections = categoriesSections.filter({$0.cattype == categoriesSections[0].cattype})
//
//                        DispatchQueue.main.async { [self] in
//
//                            servicesCV.reloadData()
//                            print("servicesCV reloaded")
//
//                        }
//
                        print("Categories", categoriesSections.count)
                        
                    }
                    catch {
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
    
extension PaysikkaHome: QRScannerCodeDelegate {
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String, scanDidCompletewith session: AVCaptureSession) {
        
        print("scanDidCompletewith session ",controller)
        
        session.stopRunning()
        
        if result.contains("upi://pay") {
            
            let enterAmonutScreen:EnterAmountScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountScreen") as! EnterAmountScreen
            enterAmonutScreen.scannedData = result
            enterAmonutScreen.from = "UPI"
            DispatchQueue.main.async {
            self.navigationController?.pushViewController(enterAmonutScreen, animated: true)
            }
            
            
        }else{
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let alert = UIAlertController(title: "Verification Failed", message: "Unable to verify QRCode \n Please try again.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Scan Again", style: .default) { action in
               
                session.startRunning()
            }
            alert.view.tintColor = UIColor.init(named: "AppColor")
        
            alert.addAction(action)
            
            controller.present(alert, animated: true)
            
           let d = controller.isBeingDismissed
            
           let p = controller.isBeingPresented
            
           print("isBeingPresented ",p)
            
            print("isBeingDismissed ",d)
        
            
        }
       
        print("result:\(result)")
          
        
    }
    
/*
}else if result.contains("MAB"){
  
    let enterAmonutScreen:EnterAmountScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountScreen") as! EnterAmountScreen
    enterAmonutScreen.scannedData = result
    enterAmonutScreen.from = "Bharat"
    DispatchQueue.main.async {
        self.navigationController?.pushViewController(enterAmonutScreen, animated: true)
        
    }*/
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
       
        print("scanDidComplete ViewC ",controller)
        
        if result.contains("upi://pay") {
            
            let enterAmonutScreen:EnterAmountScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountScreen") as! EnterAmountScreen
            enterAmonutScreen.scannedData = result
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(enterAmonutScreen, animated: true)
                
            }
            
        }else{
            
            let alert = UIAlertController(title: "Verification Failed", message: "Unable to verify QRCode. \n Please try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Scan Again", style: .default)
            alert.view.tintColor = UIColor.link
        
            alert.addAction(action)
            
            controller.present(alert, animated: true)
            
           let p = controller.isBeingPresented
            
           print("isBeingPresented ",p)
            
        }
       
        print("result:\(result)")
        
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: QRCodeError) {
        
        
        print("error:\(error.localizedDescription)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        
        print("PAYQRScanner did cancel")
        
        self.dismiss(animated: true) {
//
//            let NewHome:NewTabBar = UIStoryboard(name: "NewHome", bundle: nil).instantiateViewController(withIdentifier: "NewTabBar") as! NewTabBar
//            NewHome.modalPresentationStyle = .fullScreen
//            self.navigationController?.pushViewController(NewHome, animated: true)
        }
        
        
    }
    
}

extension PaysikkaHome:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == servicesCV{
            print("SectionsCount",categoriesSections.count)
            return categoriesSections.count
        }else{
            return 1
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == bannersCV{
            return banner_Images.count
        }else{
            
            print("numberOfItemsInSection ",categoriesSections[section].services.count)
            return categoriesSections[section].services.count
               
        }
        
//        if collectionView == bannersCV{
//        return banner_Images.count
//        }else{
//        return categoriesSections[section].services.count
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == bannersCV {
            
            let bannerCell = bannersCV.dequeueReusableCell(withReuseIdentifier: BannerCVCell.identifier, for: indexPath) as! BannerCVCell
                bannerCell.bannerImage.downloaded(from: banner_Images[indexPath.row])
            
            let imageLink = banner_Images[indexPath.row]
            print("banners: ",imageLink)
            bannerCell.contentMode = .scaleToFill
            
            return bannerCell
            
        } else {
            
          //  print("Services_Names: ",categoriesSections[indexPath.section].services[indexPath.row].name)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionsCollectionViewCell.identifier, for: indexPath) as! SectionsCollectionViewCell
            cell.providerName.text = categoriesSections[indexPath.section].services[indexPath.row].name
            cell.providerName.adjustsFontSizeToFitWidth = true
            cell.providerimg.sd_setImage(with: URL(string: categoriesSections[indexPath.section].services[indexPath.row].imageurl), placeholderImage: UIImage(named: "placeholder_image"))
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = servicesCV.cellForItem(at: indexPath) as? SectionsCollectionViewCell
        
        let icloud = categoriesSections[indexPath.section].services[indexPath.row].name
        
        print("tapped item: ",icloud)
        
        if cell?.providerName.text == "Scan QR Code" {
            
            let scanner = QRCodeScannerController()
            scanner.delegate = self
            scanner.qrScannerConfiguration.readQRFromPhotos = true
            scanner.qrScannerConfiguration = .default
            
            scanner.modalPresentationStyle = .automatic
            
            DispatchQueue.main.async { [self] in
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(scanner, animated: true)
                
            }
            
        } else if cell?.providerName.text == icloud {
            
            let mobile:MobilePrepaidViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "MobileRecharge") as! MobilePrepaidViewController
            print("prepaid nav: ",self.navigationController?.isNavigationBarHidden)
            self.navigationController?.pushViewController(mobile, animated: true)
            
        }else if cell?.providerName.text == icloud {
            
            let electricity:ProviderTBVViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "BillTBV") as! ProviderTBVViewController
            if let value = icloud{
                electricity.from = value
            }
            electricity.prefersTitle = true
            print("prepaid nav: ",self.navigationController?.isNavigationBarHidden)
            self.navigationController?.pushViewController(electricity, animated: true)
            
        }
        
//        else if cell?.providerName.text == icloud{
//
//            let dish:ProviderTBVViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "BillTBV") as! ProviderTBVViewController
//            dish.from = "DTH"
//            dish.prefersTitle = true
//            print("prepaid nav: ",self.navigationController?.isNavigationBarHidden)
//            self.navigationController?.pushViewController(dish, animated: true)
//
//        }else if cell?.providerName.text == icloud{
//
//            let broadband:ProviderTBVViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "BillTBV") as! ProviderTBVViewController
//            broadband.from = "Insurance"
//            broadband.prefersTitle = true
//            print("prepaid nav: ",self.navigationController?.isNavigationBarHidden)
//            self.navigationController?.pushViewController(broadband, animated: true)
//
//        }else if cell?.providerName.text == icloud{
//
//            let broadband:ProviderTBVViewController = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "BillTBV") as! ProviderTBVViewController
//            broadband.from = "Water"
//            broadband.prefersTitle = true
//            print("prepaid nav: ",self.navigationController?.isNavigationBarHidden)
//            self.navigationController?.pushViewController(broadband, animated: true)
//
//        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      ///  guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else { return UICollectionReusableView()}
        print("viewForSupplementaryElementOfKind: ",kind)
        
        if collectionView == servicesCV {
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else {return UICollectionReusableView()}
             
            header.headerTitle.text = categoriesSections[indexPath.section].title
            header.headerTitle.font = UIFont.boldSystemFont(ofSize: 16)
            header.headerTitle.textColor =  UIColor.init(named: "AppColor")
            
            return header
        }else{
            return UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView == servicesCV{
            return CGSize(width: view.frame.size.width, height: 40)
        }else{
            return CGSize(width:0, height: 0)
        }
        
    }
    
}

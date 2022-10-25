//
//  RechargeVC.swift
//  Paysikka
//
//  Created by Nag Marisetty on 17/10/22.
//

import UIKit
import Contacts

class RechargeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var contactsTV: UITableView!
    
    var phoneNumber:String!
    var contacts = [CNContact]()
    var filteredData = [CNContact]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: { (success, error) in
            if success {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                //  let keys = CNContactViewController.descriptorForRequiredKeys()
                //let request = CNContactFetchRequest(keysToFetch: [keys])
                do {
                    self.contacts = []
                    try store.enumerateContacts(with: request, usingBlock: { (contact, status) in
                        self.contacts.append(contact)
                    })
                } catch {
                    print("Error")
                }
                OperationQueue.main.addOperation({
                    self.contactsTV.reloadData()
                })
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = contactsTV.dequeueReusableCell(withIdentifier: "cell1")

        else {
            return UITableViewCell()
        }
          
        let contact: CNContact!
        
        if inSearchMode {
            contact = filteredData[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        
        cell.textLabel?.text = contact.givenName
        
        for number in contact.phoneNumbers{
            let phone = number.value
            print(phone)
            cell.textLabel?.text = phone as! String
            
            if let phone = number.value as? CNPhoneNumber {
                print("phone number ",phone.stringValue)
                phoneNumber = phone.stringValue
//                cell.numberLbl.text = phone.stringValue
                cell.imageView?.image = UIImage(named: "self transfer")
            } else {
                print("number.value not of type CNPhoneNumber")
            }
        }
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> String? {
        
        return "My Contacts"
    }
    
    
}

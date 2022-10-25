//
//  TransactionsModel.swift
//  Paysikka
//
//  Created by George Praneeth on 11/07/22.
//

import Foundation

class TransactionModel {
    
        var id: String?
        var userID: String?
        var amount: Int?
        var status: String?
        var grams: Double?
        var transactionid: String?
        var points: Int?
        var type: String?
        var message: String?
        var date: String?
        var v: Int?

    init(fromDictionary dictionary: [String:Any]) {
        
        self.id = dictionary["_id"] as? String
        self.userID = dictionary["userid"] as? String
        self.amount = dictionary["amount"] as? Int
        self.status = dictionary["status"] as? String
        self.grams = dictionary["grams"] as? Double
        self.transactionid = dictionary["transactionid"] as? String
        self.message = dictionary["message"] as? String
        self.type = dictionary["type"] as? String
        
    }
   
}

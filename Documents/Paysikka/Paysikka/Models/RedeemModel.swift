//
//  RedeemModel.swift
//  Paysikka
//
//  Created by George Praneeth on 11/07/22.
//

import Foundation

class RedeemModel{

    var dataformat : Dataformat?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataformatData = dictionary["dataformat"] as? [String:Any]{
            dataformat = Dataformat(fromDictionary: dataformatData)
        }
      
        
    }

}

class Dataformat {
    
    var descriptionField : String?
    var isAddress : Bool?
    var processed : Bool?
    var transactionId : Int?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        descriptionField = dictionary["description"] as? String
        isAddress = dictionary["is_address"] as? Bool
        processed = dictionary["processed"] as? Bool
        transactionId = dictionary["transactionId"] as? Int
    }

}

//
//  BrowsePlans.swift
//  Paysikka
//
//  Created by George Praneeth on 16/09/22.
//

import Foundation

class BrowsePlansModel{

    var amount : String!
    var data : String!
    var descriptionField : String!
    var mode : String!
    var operatorName : String!
    var per : String!
    var type : String!
    var validity : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]){
        amount = dictionary["amount"] as? String
        data = dictionary["data"] as? String
        descriptionField = dictionary["description"] as? String
        mode = dictionary["mode"] as? String
        operatorName = dictionary["operator"] as? String
        per = dictionary["per"] as? String
        type = dictionary["type"] as? String
        validity = dictionary["validity"] as? String
    }

}

//
//  OperatorsModel.swift
//  Paysikka
//
//  Created by George Praneeth on 12/09/22.
//

import Foundation

class OperatorsModel {

    var accountDisplay : String!
    var amountRange : String!
    var bBPS : String!
    var billFetch : String!
    var hSNSAC : String!
    var operatorCode : String!
    var operatorName : String!
    var optionalParameter : String!
    var partialPay : String!
    var sNo : String!
    var serviceType : String!
    var tDS : String!
    var imageUrl:String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        accountDisplay = dictionary["AccountDisplay"] as? String
        amountRange = dictionary["AmountRange"] as? String
        bBPS = dictionary["BBPS"] as? String
        billFetch = dictionary["BillFetch"] as? String
        hSNSAC = dictionary["HSN_SAC"] as? String
        operatorCode = dictionary["OperatorCode"] as? String
        operatorName = dictionary["OperatorName"] as? String
        optionalParameter = dictionary["OptionalParameter"] as? String
        partialPay = dictionary["PartialPay"] as? String
        sNo = dictionary["SNo"] as? String
        serviceType = dictionary["ServiceType"] as? String
        tDS = dictionary["TDS"] as? String
        imageUrl = dictionary["imageurl"] as? String
    }

}

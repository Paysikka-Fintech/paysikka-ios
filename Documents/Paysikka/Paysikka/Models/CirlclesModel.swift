//
//  CirlclesModel.swift
//  Paysikka
//
//  Created by George Praneeth on 13/09/22.
//

import Foundation

class CirclesModel {

    var area : String!
    var code : String!
    var sNo : String!
    var type : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        area = dictionary["Area"] as? String
        code = dictionary["Code"] as? String
        sNo = dictionary["SNo"] as? String
        type = dictionary["Type"] as? String
    }

}

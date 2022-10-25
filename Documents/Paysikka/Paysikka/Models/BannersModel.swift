//
//  BannersModel.swift
//  Paysikka
//
//  Created by George Praneeth on 14/07/22.
//

import Foundation

class BannersModel {

    var v : Int?
    var id : String?
    var date : String?
    var imageUrl : String?
    var status : Int?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        date = dictionary["date"] as? String
        imageUrl = dictionary["image_url"] as? String
        status = dictionary["status"] as? Int
    }

}

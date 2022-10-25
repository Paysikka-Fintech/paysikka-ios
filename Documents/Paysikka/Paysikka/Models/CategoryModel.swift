//
//  CategoryModel.swift
//  Paysikka
//
//  Created by George Praneeth on 06/10/22.
//

import Foundation

class CategoryModel{

    var services : [Service]!
    var title : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        services = [Service]()
        if let servicesArray = dictionary["services"] as? [[String:Any]]{
            for dic in servicesArray{
                let value = Service(fromDictionary: dic)
                services.append(value)
            }
        }
        title = dictionary["title"] as? String
    }

}

class Service{

    var cattype : String!
    var imageurl : String!
    var name : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cattype = dictionary["cattype"] as? String
        imageurl = dictionary["imageurl"] as? String
        name = dictionary["name"] as? String
    }

}

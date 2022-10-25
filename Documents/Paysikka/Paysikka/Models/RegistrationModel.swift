//
//  loginModel.swift
//  Paysikka
//
//  Created by George Praneeth on 06/07/22.
//

import Foundation

class RegistrationModel {

    var accessToken : String?
    var checkuser : Checkuser?
    var user : User?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        accessToken = dictionary["accessToken"] as? String
        if let checkuserData = dictionary["checkuser"] as? [String:Any]{
            checkuser = Checkuser(fromDictionary: checkuserData)
        }
        if let userData = dictionary["user"] as? [String:Any]{
            user = User(fromDictionary: userData)
        }
    }

}

class User{

    var id : String?
    var customerid : Int?
    var date : String?
    var email : String?
    var existance : Bool?
    var gsToken : String?
    var name : String?
    var phone : Int?
    var userid : Int?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        customerid = dictionary["customerid"] as? Int
        date = dictionary["date"] as? String
        email = dictionary["email"] as? String
        existance = dictionary["existance"] as? Bool
        gsToken = dictionary["gs_token"] as? String
        name = dictionary["name"] as? String
        phone = dictionary["phone"] as? Int
        userid = dictionary["userid"] as? Int
    }

}

class Checkuser{

    var token : String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        token = dictionary["token"] as? String
    }

}

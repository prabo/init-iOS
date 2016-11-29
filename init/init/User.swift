//
//	RootClass.swift
//
//	Create by Atsuo on 29/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON


class User : NSObject, NSCoding{
    
    var accessToken : String!
    var id : Int!
    var tokenType : String!
    var username : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accessToken = json["access_token"].stringValue
        id = json["id"].intValue
        tokenType = json["token_type"].stringValue
        username = json["username"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if accessToken != nil{
            dictionary["access_token"] = accessToken
        }
        if id != nil{
            dictionary["id"] = id
        }
        if tokenType != nil{
            dictionary["token_type"] = tokenType
        }
        if username != nil{
            dictionary["username"] = username
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        accessToken = aDecoder.decodeObject(forKey: "access_token") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        tokenType = aDecoder.decodeObject(forKey: "token_type") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if accessToken != nil{
            aCoder.encode(accessToken, forKey: "access_token")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if tokenType != nil{
            aCoder.encode(tokenType, forKey: "token_type")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        
    }
    
}

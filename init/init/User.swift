//
//	RootClass.swift
//
//	Create by Atsuo on 28/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class User : NSObject{
    
    var accessToken : String!
    var id : Int!
    var tokenType : String!
    var username : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        accessToken = dictionary["access_token"] as? String
        id = dictionary["id"] as? Int
        tokenType = dictionary["token_type"] as? String
        username = dictionary["username"] as? String
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        var dictionary = NSMutableDictionary()
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
        tokenType = aDecoder.decodeObject(forKey:"token_type") as? String
        username = aDecoder.decodeObject(forKey:"username") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
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

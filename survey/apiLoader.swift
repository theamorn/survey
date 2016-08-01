//
//  apiLoader.swift
//  survey
//
//  Created by Amorn Apichattanakul on 7/29/16.
//  Copyright © 2016 Nimble. All rights reserved.
//

import Alamofire

class apiLoader:NSObject{
    
    func getAPI(apiCaller:String, callback:(jsonData:NSArray) -> ()) {
        
        let params = ["access_token": "\(config.keyID)"]
        
        Alamofire.request(.GET, apiCaller, parameters: params)
            .responseJSON{ response in
            if let JSON = response.result.value {
                let db = dbConnect()
                db.saveData(JSON as! NSArray, DB: config.survey)
                callback(jsonData: JSON as! NSArray)
            } else {
                print("error problem \(response)")
            }
        }
    }
}
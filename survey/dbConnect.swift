//
//  dbConnect.swift
//  survey
//
//  Created by Amorn Apichattanakul on 7/29/16.
//  Copyright © 2016 Nimble. All rights reserved.
//

import Foundation
import CoreData

class dbConnect{
    func saveData(data:NSArray, DB:String){
        
        switch DB{
        case config.survey :
            
            for oneData in data{
            
                let database: [String:AnyObject] = [
                    ImageIntro.key.title : oneData.valueForKey(ImageIntro.key.title) as! String,
                    ImageIntro.key.desc : oneData.valueForKey(ImageIntro.key.desc) as! String,
                    ImageIntro.key.coverImg : oneData.valueForKey(ImageIntro.key.coverImg) as! String
                ]
                
                _ = ImageIntro(dictionary: database, context: sharedContext)
                self.sharedContext.performBlock({ () -> Void in
                    //self.sharedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    shareDB.sharedInstance().saveContext()
                })
            }
            
        default :
            print("no existed API")
        }
    }
    
    func clearData(){
        let fetchRequest = NSFetchRequest(entityName: "ImageIntro")
        do{
            let fetchObjects = try self.sharedContext.executeFetchRequest(fetchRequest)
            for object in fetchObjects{
                self.sharedContext.deleteObject(object as! NSManagedObject)
            }
            
            try self.sharedContext.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }

    }
    
    
    func clearData(DBName:String){
        
        let fetchRequest = NSFetchRequest(entityName: DBName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.sharedContext.executeRequest(deleteRequest)
            self.sharedContext.performBlock({ () -> Void in
                shareDB.sharedInstance().saveContext()
            })
            print("clear data")
        } catch let error as NSError {
            print ("Problem Clear Data: \(error.localizedDescription)")
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return shareDB.sharedInstance().managedObjectContext
    }

}
